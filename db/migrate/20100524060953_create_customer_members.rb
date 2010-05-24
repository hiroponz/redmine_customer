class CreateCustomerMembers < ActiveRecord::Migration
  def self.up
    create_table :customer_members do |t|
      t.references :customer, :null=>false
      t.references :project, :null=>false
    end
    add_index :customer_members, [:customer_id, :project_id]
  end

  def self.down
    drop_table :customer_members
  end
end
