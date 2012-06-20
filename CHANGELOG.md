# CHANGELOG

## Development

* Enables socket keepalive option on APNS client sockets (Kyle Drake)

## 0.0.13

* Fixes a bug where closing a Grocer.server could result in an
  `Errno::ENOTCONN` being raised (seems isolated to OS X).
