class ContactForm < ActiveRecord::Base
  has_and_belongs_to_many :customers

  def to_s
    name
  end
end
