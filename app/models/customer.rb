class Customer < ActiveRecord::Base
  has_many :issues
  has_and_belongs_to_many :contact_forms
  belongs_to :neighborhood

  acts_as_customizable
  
  validates_presence_of :name

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
    :allow_nil => true, :allow_blank => true
  
  def self.search(query)
    find :all, :conditions => [
      "name like :query or cpf like :query or email like :query or rg like :query",
      {:query => "%#{query}%"}
    ]

  end

  def neighborhood_other
  end

  def neighborhood_other=(value)
    if value.present?
      self.neighborhood = Neighborhood.create(:name => value)
    end
  end

  def pretty_name
    date = I18n.l(birthday) if birthday
    cpf_text = cpf if cpf.present?
    [name, date, cpf_text].compact.join(', ')
  end

  def to_s
    pretty_name
  end
end
