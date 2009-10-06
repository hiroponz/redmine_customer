class Customer < ActiveRecord::Base
  has_many :issues

  acts_as_customizable
  
  # name or company is mandatory
  validates_presence_of :name, :if => :company_unsetted
  validates_presence_of :company, :if => :name_unsetted
  validates_uniqueness_of :name, :scope => :company

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
    :allow_nil => true, :allow_blank => true
  
  def self.search(query)
    find :all, :conditions => [
      "name like :query or company like :query",
      {:query => "%#{query}%"}
    ]

  end

  def pretty_name
     result = []
     [self.name, self.company].each do |field|
       result << field unless field.blank?
     end
     
     return result.join(", ")
  end

  def to_s
    pretty_name
  end
  
  private
  
  def name_unsetted
    self.name.blank?
  end
  
  def company_unsetted
    self.company.blank?
  end

end
