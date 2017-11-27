require 'spec_helper'

describe Validator, '.valid?' do
  it 'returns true when message and recipients are valid' do
    message    = 'valid'
    recipients = ['user@example.com', 'user2@example.com']

    expect(validate(message, recipients)).to be(true)
  end

  it 'returns false when message is not valid' do
    message    = ''
    recipients = ['user@example.com', 'user2@example.com']

    expect(validate(message, recipients)).to be(false)
  end

  it 'returns false when recipients are not valid' do
    message    = 'valid'
    recipients = ['user.example.com', 'user2@example.com']

    expect(validate(message, recipients)).to be(false)
  end

  private

  def validate(message, recipients)
    Validator.valid? message: message, recipients: recipients
  end
end
