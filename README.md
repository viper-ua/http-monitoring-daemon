# http-monitoring-daemon
Simple daemon for monitoring availability of HTTP resources


## How to work with
- install dependencies
```
gem install mail
```

- run daemon
```
ruby monitor.rb
```

- terminate daemon
```
kill XXXX
```
>where XXXX - process id of script 

## Change some settings
Mail server settings can be adjusted in script section as below:
``` ruby
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
```
Mail addresses and body can be adjusted in this section:
``` ruby
  Mail.deliver do
    from    'xxx@gmail.com'
    to      'xxx@gmail.com'
    subject 'Some of monitored sites changed their state'
    body    "URI #{text_uri} changed state from #{old_state} to #{new_state}"
  end
 ```
