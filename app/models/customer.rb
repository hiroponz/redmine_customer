class Customer < ActiveRecord::Base
  has_many :issues
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

  def pretty_name
    "#{name}, #{cpf}"
  end

  def to_s
    pretty_name
  end
end
