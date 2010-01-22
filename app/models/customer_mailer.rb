class CustomerMailer < Mailer
  def message(customer)
    recipients customer.email
    subject Setting.plugin_notification['subject']
    content_type "text/html"

    text = parse_tags Setting.plugin_notification['body'], customer
    body :text => text
  end

  private

  def parse_tags(text, customer)
    tags = {
      :id => customer.id.to_s,
      :nome => customer.name,
      :cpf => customer.cpf
    }
    tags.each do |key, value|
      text.gsub! /\{\{#{key}\}\}/, value
    end
    text
  end
end

