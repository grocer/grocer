# CHANGELOG

## Unreleased

## 0.4.1

* Fix `Grocer::NotificationReader`, ensuring it sanitizes incoming `aps`
  payload keys before building a new `Grocer::Notification`.

## 0.4.0

* Add support for `content-available` for background fetches (iOS 7) for all
  types of Notifications ([Zack Parker](https://github.com/somezack))

## 0.3.4

* Add `Grocer::MobileDeviceManagementNotification` to send PushMagic tokens.
  ([Osis](https://github.com/Osis))
* Fix `Grocer::NewsstandNotification` payload
  ([khelll](https://github.com/khelll))

## 0.3.3

* Notifications that only include a custom payload are now valid.
  ([overlycommonname](https://github.com/overlycommonname))

## 0.3.2

* Validate the size of the payload before sending a notification

## 0.3.1

* Move repo to the Grocer organization.
* Automatically require `passbook_notification` when `require 'grocer'`.
  ([lgleasain](https://github.com/lgleasain))

## 0.3.0

* Add `Grocer::PassbookNotification` for sending, well... Passbook
  notifications. This kind of notification requires no payload.
* Determining current environment is case-insensitive ([Oriol
  Gual](https://github.com/oriolgual))

## 0.2.0

* Don't retry connection when the certificate has expired. ([Kyle
  Drake](https://github.com/kyledrake) and [Jesse
  Storimer](https://github.com/jstorimer))

## 0.1.1

* Warn that `jruby-openssl` is needed on JRuby platform. ([Kyle
  Drake](https://github.com/kyledrake))

## 0.1.0

* Supports non-ASCII characters in notifications
* Enables socket keepalive option on APNS client sockets ([Kyle
  Drake](https://github.com/kyledrake))
* Certificate can be any object that responds to #read ([Kyle
  Drake](https://github.com/kyledrake))

## 0.0.13

* Fixes a bug where closing a Grocer.server could result in an
  `Errno::ENOTCONN` being raised (seems isolated to OS X).
