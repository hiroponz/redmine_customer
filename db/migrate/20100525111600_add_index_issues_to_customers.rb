class AddIndexIssuesToCustomers < ActiveRecord::Migration
  def self.up
    add_index :issues, :customer_id
  end

  def self.down
    remove_index :issues, :customer_id
  end
end

