class CustomerMember < ActiveRecord::Base
  belongs_to :customer
  belongs_to :project

  validates_presence_of :customer, :project
  validates_uniqueness_of :customer_id, :scope => :project_id
end
