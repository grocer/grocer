# Grocer

[![Build Status](https://secure.travis-ci.org/highgroove/grocer.png)](http://travis-ci.org/highgroove/grocer)

*grocer* interfaces with the [Apple Push Notification
Service](http://developer.apple.com/library/mac/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/ApplePushService/ApplePushService.html)
to send push notifications to iOS devices.

There are other gems out there to do this, but *grocer* plans to be the
cleanest, most extensible, and best maintained.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grocer'
```

## Usage

### Connecting

```ruby
# `certificate` is the only required option; the rest will default to the values
# shown here.
#
# Information on obtaining a `.pem` file for use with `certificate` is shown
# later.
connection = Grocer::Connection.new(
    certificate: "/path/to/cert.pem",      # required
    passphrase:  "",                       # optional
    gateway:     "gateway.push.apple.com", # optional; "gateway.sandbox.push.apple.com" for development
    port:        2195                      # optional
)
```

### Sending Notifications

```ruby
# `device_token` and either `alert` or `badge` are required.
#
# Information on obtaining `device_token` is shown later.
notification = Grocer::Notification.new(
  device_token: "fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2",
  alert:        "Hello from Grocer!",
  badge:        42,
  sound:        "siren.aiff",         # optional
  expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
  identifier:   1234                  # optional
)

# TODO: How does this API work?
```

### Errors

TODO

### Feedback

```ruby
feedback_connection = Grocer::Connection.new(
  certificate: "/path/to/cert.pem",       # required
  gateway:     "feedback.push.apple.com", # required; "feedback.sandbox.push.apple.com" for development
  port:        2196                       # required
)
feedback = Grocer::Feedback.new(connection)

feedback.each do |attempt|
  puts "Device #{attempt.device_token} failed at #{attempt.timestamp}
end
```

### Device Token

TODO: Describe how to get a device token

### Certificate File

TODO: Describe how to get a .pem
