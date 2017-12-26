require 'net/http'
require 'mail'

URI_TO_CHECK = [ 'https://pokupon.ua',
                 'https://partner.pokupon.ua',
                 'http://localhost:3000'
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

  # puts "Mail sent: #{old_state} changed to #{new_state}"

  Mail.deliver do
    from    '@gmail.com'
    to      '@gmail.com'
    subject 'Some of monitored sites changed their state'
    body    "URI #{text_uri} changed state from #{old_state} to #{new_state}"
  end
end

last_states = Hash.new("200:OK")

Process.daemon
while true do 
  # puts "-"*30
  # puts Time.now.strftime('%Y-%m-%d %H:%M:%S')
  # puts "-"*30
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

    # puts "#{uri.host} => #{new_state}"
    send_alert_mail(text_uri, last_states[text_uri], new_state) if last_states[text_uri] != new_state
    last_states[text_uri] = new_state
  end
  sleep(60)

end
