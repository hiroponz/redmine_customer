class CustomerMailer < Mailer
  def single_message(customer, options)
    recipients customer.email
    subject options[:subject]
    content_type "text/html"

    text = parse_tags options[:body], customer
    body :text => text
  end

  private

  def parse_tags(text, customer)
    tags = {
      :id => customer.id.to_s,
      :nome => customer.name
    }
    tags.each do |key, value|
      text.gsub! /\{\{#{key}\}\}/, value
    end
    text
  end
end

