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
      notification.identifier.should == 1234
    end

    it "reads expiry" do
      io.write(Grocer::Notification.new(expiry: Time.utc(2013, 3, 24), alert: "Foo").to_bytes)
      io.rewind

      notification = subject.first
      notification.expiry.should == Time.utc(2013, 3, 24)
    end

    it "reads device token" do
      io.write(Grocer::Notification.new(device_token: 'fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2', alert: "Foo").to_bytes)
      io.rewind

      notification = subject.first
      notification.device_token.should == 'fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'
    end

    it "reads alert" do
      io.write(Grocer::Notification.new(alert: "Foo").to_bytes)
      io.rewind

      notification = subject.first
      notification.alert.should == "Foo"
    end

    it "reads badge" do
      io.write(Grocer::Notification.new(alert: "Foo", badge: 5).to_bytes)
      io.rewind

      notification = subject.first
      notification.badge.should == 5
    end

    it "reads sound" do
      io.write(Grocer::Notification.new(alert: "Foo", sound: "foo.aiff").to_bytes)
      io.rewind

      notification = subject.first
      notification.sound.should == "foo.aiff"
    end

    it "reads custom attributes" do
      io.write(Grocer::Notification.new(alert: "Foo", custom: { foo: "bar" }).to_bytes)
      io.rewind

      notification = subject.first
      notification.custom.should == { foo: "bar" }
    end
  end
end
