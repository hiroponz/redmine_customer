class AddProjectIdToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :project_id, :integer
  end

  def self.down
    remove_column :customers, :project_id
  end
end
