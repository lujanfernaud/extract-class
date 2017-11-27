require 'spec_helper'

describe EmailParser, '#email_list' do
  it 'gives back a parsed email list' do
    recipients    = "user@example.com\n,;user2@example.com"
    email_parser  = EmailParser.new(recipients)
    parsed_emails = ['user@example.com', 'user2@example.com']

    expect(email_parser.email_list).to eq(parsed_emails)
  end
end

describe EmailParser, '#valid_emails?' do
  it 'returns true when all emails are valid' do
    recipients   = "user@example.com\n,;user2@example.com"
    email_parser = EmailParser.new(recipients)

    expect(email_parser.valid_emails?).to eq(true)
  end

  it 'returns false when not all emails are valid' do
    recipients   = 'user@example.com\n,;user2.example.com'
    email_parser = EmailParser.new(recipients)

    expect(email_parser.valid_emails?).to eq(false)
  end
end
