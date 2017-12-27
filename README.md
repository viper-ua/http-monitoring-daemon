# http-monitoring-daemon
Simple daemon for monitoring availability of HTTP resources


## How to work with
- install dependencies
```bash
gem install mail
gem install daemons
```

- change mail settings in `monitor.rb`, see details below

- make control script executable
```bash
chmod +x monitor_control
```

- run daemon
```bash
./monitor_control start
```
  - run without "daemonization"
  Use key `-t` or `--ontop` when running `monitor_control`

- terminate daemon
```bash
./monitor_control stop
```

- check daemon running status
```bash
./monitor_control status
``` 

- other options, see output of:
```bash
./monitor_control help
```


## Change some settings
Default mail settings are to send mail to localhost, port 25 (as example, Postfix). They can be adjusted in below section inside script body:
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
