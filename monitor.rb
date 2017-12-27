require 'net/http'
require 'mail'

URI_TO_CHECK = [ 'https://pokupon.ua',
                 'https://partner.pokupon.ua'
               ].freeze

Mail.defaults do
  delivery_method :smtp, { :address              => "localhost",
                           :port                 => 25,
                           :domain               => 'localhost.localdomain',
                           :user_name            => nil,
                           :password             => nil,
                           :authentication       => nil,
                           :enable_starttls_auto => true,
                           :openssl_verify_mode  => OpenSSL::SSL::VERIFY_NONE }
end

def send_alert_mail(text_uri, old_state, new_state)
  Mail.deliver do
    from    'donotreply@localhost'
    to      'xxx@gmail.com'
    subject 'Monitored resource has changed its state'
    body    "Resource #{text_uri} changed state from #{old_state} to #{new_state}\n"\
           +"Time: #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
  end
  puts "Resource #{text_uri} changed state from #{old_state} to #{new_state}" 
end

last_states = Hash.new("200:OK")

while true do 
  URI_TO_CHECK.each do |text_uri|
    uri = URI(text_uri)
    response = nil
    
    begin    
      Net::HTTP.start(uri.host, uri.port, use_ssl: (uri.scheme == 'https')) do |http|
        response = http.head('/')
      end
      new_state = "#{response&.code}:#{response&.message}"
    rescue Exception => e  
      new_state =  e.to_s
    end

    send_alert_mail(text_uri, last_states[text_uri], new_state) if last_states[text_uri] != new_state
    last_states[text_uri] = new_state
  end
  sleep(60)
end
