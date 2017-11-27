# Upcase Refactoring Trail

## Extract Class

Refactoring exercise using the [Extract Class](https://refactoring.com/catalog/extractClass.html) refactoring for the [Upcase Refactoring Trail](https://thoughtbot.com/upcase/refactoring).

### Extract Class

> You have one class doing work that should be done by two. Create a new class and move the relevant fields and methods from the old class into the new class. -- Martin Fowler

#### Before

```ruby
# survey_inviter.rb

class SurveyInviter
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  def initialize(attributes = {})
    @survey = attributes[:survey]
    @message = attributes[:message] || ''
    @recipients = attributes[:recipients] || ''
    @sender = attributes[:sender]
  end

  attr_reader :message, :recipients, :survey

  def valid?
    valid_message? && valid_recipients?
  end

  def deliver
    recipient_list.each do |email|
      invitation = Invitation.create(
        survey: @survey,
        sender: @sender,
        recipient_email: email,
        status: 'pending'
      )
      Mailer.invitation_notification(invitation, @message)
    end
  end

  def invalid_recipients
    @invalid_recipients ||= recipient_list.map do |item|
      unless item.match(EMAIL_REGEX)
        item
      end
    end.compact
  end

  private

  def valid_message?
    @message.present?
  end

  def valid_recipients?
    invalid_recipients.empty?
  end

  def recipient_list
    @recipient_list ||= @recipients.gsub(/\s+/, '').split(/[\n,;]+/)
  end
end
```

#### After

```ruby
# survey_inviter.rb

class SurveyInviter
  def initialize(attributes = {})
    @survey     = attributes[:survey]
    @message    = attributes[:message] || ''
    @recipients = EmailParser.email_list_for attributes[:recipients]
    @sender     = attributes[:sender]
  end

  attr_reader :message, :recipients, :survey

  def valid?
    Validator.valid? message: message, recipients: recipients
  end

  def deliver
    recipients.each do |email|
      invitation = Invitation.create(
        survey: @survey,
        sender: @sender,
        recipient_email: email,
        status: 'pending'
      )
      Mailer.invitation_notification(invitation, @message)
    end
  end
end
```

```ruby
# email_parser.rb

class EmailParser
  WHITESPACE = /\s+/
  DELIMITERS = /[\n,;]+/

  def self.email_list_for(recipients)
    new(recipients).email_list
  end

  def initialize(recipients)
    @recipients = recipients || ''
  end

  def email_list
    @email_list ||= parse_recipients
  end

  private

  def parse_recipients
    @recipients.gsub(WHITESPACE, '').split(DELIMITERS)
  end
end
```

```ruby
# validator.rb

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
```
