class AddObsToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :obs, :text
  end

  def self.down
    remove_column :customers, :obs
  end
end
