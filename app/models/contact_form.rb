class ContactForm < ActiveRecord::Base
  has_and_belongs_to_many :customers
  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    name
  end
end
