class Customer < ActiveRecord::Base
  unloadable

  has_many :issues
  has_many :customer_members, :dependent => :destroy
  has_many :projects, :through => :customer_members

  acts_as_audited
  acts_as_customizable

  validates_presence_of :name

  default_scope :order => 'name'

  def self.search(query)
    all(
      :conditions => [
        'customers.name like :query or custom_values.value like :query',
        {:query => "%#{query}%"}
      ],
      :include => :custom_values
    )
  end

  def to_s
    name
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
    all.collect {|customer| [customer.to_s, customer.id.to_s]}
  end

  private

  def audit_create
    write_audit(:action => 'create', :changes => audited_attributes.merge(custom_values_changes))
  end

  def audit_update
    changes = audited_changes.merge(custom_values_changes)
    unless changes.empty?
      write_audit(:action => 'update', :changes => changes)
    end
  end

  def custom_values_changes
    returning({}) do |changes|
      custom_values.each do |custom_value|
        if custom_value.changed?
          changes["cf-#{custom_value.custom_field.id}"] = custom_value.changes['value']
        end
      end
    end
  end
end
