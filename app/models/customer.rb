class Customer < ActiveRecord::Base
  unloadable

  has_many :issues
  has_and_belongs_to_many :contact_forms
  belongs_to :project
  belongs_to :neighborhood
  belongs_to :address_type

  acts_as_audited
  acts_as_customizable

  default_scope :order => 'name'

  usar_como_cpf :cpf
  
  validates_presence_of :name
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
    :allow_nil => true, :allow_blank => true

  before_save :remove_address_type, :if => 'address.blank?'
  before_save :update_contact_forms_cache
  
  def self.search(query)
    find :all, :conditions => [
      search_query,
      {:query => "%#{query}%"}
    ]
  end

  def self.search_query
    search_fields.join(' like :query or ') + ' like :query'
  end

  def self.search_fields
    columns.collect &:name
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

  def self.from_email(email)
    addr = email.from_addrs.to_a.first
    if addr && !addr.spec.blank?
      customer = Customer.new
      customer.mail = addr.spec
      customer.name = addr.name.blank? ? addr.spec.gsub(/@.*$/, '') : addr.name
      
      customer.save ? customer : nil
    end
  end

  def self.list_for_select
    all.collect {|c| [c.to_s, c.id.to_s]}
  end

  private

  def remove_address_type
    self.address_type = nil
  end

  def update_contact_forms_cache
    self.contact_forms_cache = contact_forms.to_sentence
  end
end
