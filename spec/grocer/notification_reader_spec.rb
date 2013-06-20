require 'spec_helper'
require 'stringio'
require 'grocer/notification_reader'

describe Grocer::NotificationReader do
  let(:io) { StringIO.new }
  subject { described_class.new(io) }

  context "Version 1 messages" do
    it "reads identifier" do
      io.write(Grocer::Notification.new(identifier: 1234, alert: "Foo").to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.identifier).to eq(1234)
    end

    it "reads expiry" do
      io.write(Grocer::Notification.new(expiry: Time.utc(2013, 3, 24), alert: "Foo").to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.expiry).to eq(Time.utc(2013, 3, 24))
    end

    it "reads device token" do
      io.write(Grocer::Notification.new(device_token: 'fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2', alert: "Foo").to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.device_token).to eq('fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2')
    end

    it "reads alert" do
      io.write(Grocer::Notification.new(alert: "Foo").to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.alert).to eq("Foo")
    end

    it "reads badge" do
      io.write(Grocer::Notification.new(alert: "Foo", badge: 5).to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.badge).to eq(5)
    end

    it "reads sound" do
      io.write(Grocer::Notification.new(alert: "Foo", sound: "foo.aiff").to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.sound).to eq("foo.aiff")
    end

    it "reads custom attributes" do
      io.write(Grocer::Notification.new(alert: "Foo", custom: { foo: "bar" }).to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.custom).to eq({ foo: "bar" })
    end

    it "reads content-available" do
      io.write(Grocer::Notification.new(alert: "Foo", content_available: true).to_bytes)
      io.rewind

      notification = subject.first
      expect(notification.content_available).to be_true
    end
  end
end
