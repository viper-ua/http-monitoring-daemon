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
Mail server settings can be adjusted in script section as below
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
