require 'spec_helper'

describe EmailParser, '.email_list_for' do
  it 'gives back a parsed email list' do
    recipients    = "user@example.com\n,;user2@example.com"
    parsed_emails = ['user@example.com', 'user2@example.com']

    expect(EmailParser.email_list_for(recipients)).to eq(parsed_emails)
  end
end
