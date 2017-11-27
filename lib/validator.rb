class Validator
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  def self.valid?(message:, recipients:)
    new(message, recipients).valid?
  end

  def initialize(message, recipients)
    @message    = message
    @recipients = recipients
  end

  def valid?
    valid_message? && valid_recipients?
  end

  private

  def valid_message?
    @message.present?
  end

  def valid_recipients?
    invalid_emails.empty?
  end

  def invalid_emails
    @invalid_emails ||= @recipients.reject(&valid_emails)
  end

  def valid_emails
    proc { |item| item if item.match(EMAIL_REGEX) }
  end
end
