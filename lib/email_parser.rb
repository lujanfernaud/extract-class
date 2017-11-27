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
