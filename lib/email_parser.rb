class EmailParser
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  TRAILING_WHITESPACE = /\s+/
  NEWLINE = /[\n,;]+/

  def initialize(recipients)
    @recipients = recipients
  end

  def email_list
    @email_list ||= parse_recipients
  end

  def valid_emails?
    invalid_emails.empty?
  end

  private

  def parse_recipients
    @recipients.gsub(TRAILING_WHITESPACE, '').split(NEWLINE)
  end

  def invalid_emails
    @invalid_emails ||= email_list.map do |item|
      item unless item.match(EMAIL_REGEX)
    end.compact
  end
end
