# CHANGELOG

## 0.2.0

* Don't retry connection when the certificate has expired. (Kyle Drake and
  Jesse Storimer)

## 0.1.1

* Warn that `jruby-openssl` is needed on JRuby platform. (Kyle Drake)

## 0.1.0

* Enables socket keepalive option on APNS client sockets (Kyle Drake)
* Supports non-ASCII characters in notifications (Patrick Van Stee, Andy
  Lindeman)
* Certificate can be any object that responds to #read (Kyle Drake)

## 0.0.13

* Fixes a bug where closing a Grocer.server could result in an
  `Errno::ENOTCONN` being raised (seems isolated to OS X).
