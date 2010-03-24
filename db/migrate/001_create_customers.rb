# Use rake db:migrate_plugins to migrate installed plugins
class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.column :name, :string
      t.column :email, :string
    end
  end

  def self.down
    drop_table :customers
  end
end
