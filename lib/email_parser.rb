class EmailParser
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  TRAILING_WHITESPACE = /\s+/
  DELIMITERS = /[\n,;]+/

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
    @recipients.gsub(TRAILING_WHITESPACE, '').split(DELIMITERS)
  end

  def invalid_emails
    @invalid_emails ||= email_list.reject(&valid_emails)
  end

  def valid_emails
    proc { |item| item if item.match(EMAIL_REGEX) }
  end
end
