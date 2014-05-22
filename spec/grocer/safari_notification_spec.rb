# encoding: UTF-8
require 'spec_helper'
require 'grocer/safari_notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::SafariNotification do
  describe 'binary format' do
    let(:payload_options) {
      {
        title: 'Grocer Update!',
        body: 'Grocer now supports Safari Notifications',
        action: 'View',
        url_args: ['message_id', '124234']
      }
    }
    let(:payload) { payload_hash(notification) }

    include_examples 'a notification'

    it 'encodes title as part of the payload' do
      notification.title = 'Hello World!'
      expect(payload[:aps][:alert][:title]).to eq('Hello World!')
    end

    it 'encodes body as part of the payload' do
      notification.body = 'In the body'
      expect(payload[:aps][:alert][:body]).to eq('In the body')
    end

    it 'encodes action as part of the payload' do
      notification.action = 'Launch'
      expect(payload[:aps][:alert][:action]).to eq('Launch')
    end

    it 'encodes url-args payload attributes' do
      notification.url_args = ['hello', 'world']
      expect(payload[:aps][:'url-args']).to eq(['hello','world'])
    end

    it 'is valid' do
      expect(notification.valid?).to be true
    end

    context 'missing parameters' do
      context 'title' do
        let(:payload_options) { { alert: { body: 'This is a body' } } }

        it 'raises an error when title is missing' do
          expect { notification.to_bytes }.to raise_error(ArgumentError)
        end

        it 'is not valid' do
          expect(notification.valid?).to be false
        end
      end

      context 'body' do
        let(:payload_options) { { alert: { title: 'This is a title' } } }

        it 'raises an error when body is missing' do
          expect { notification.to_bytes }.to raise_error(ArgumentError)
        end

        it 'is not valid' do
          expect(notification.valid?).to be false
        end
      end
    end

    context 'oversized payload' do
      let(:payload_options) { { alert: { title: 'Test', body: 'a' * (Grocer::Notification::MAX_PAYLOAD_SIZE + 1) } } }

      it 'raises an error when the size of the payload in bytes is too large' do
        expect { notification.to_bytes }.to raise_error(Grocer::PayloadTooLargeError)
      end

      it 'is not valid' do
        expect(notification.valid?).to be false
      end
    end

    context 'with a complete alert hash passed to the initializer' do
      let(:payload_options) {
        {
          alert: {
            title: 'Title',
            body: 'Body',
            action: 'View'
          },
          url_args: ['hello', 'world']
        }
      }

      it 'has the correct title' do
        expect(notification.title).to eq('Title')
      end

      it 'has the correct body' do
        expect(notification.body).to eq('Body')
      end

      it 'has the correct action' do
        expect(notification.action).to eq('View')
      end

      it 'has the correct url-args' do
        expect(notification.url_args).to eq(['hello','world'])
      end
    end
  end
end
