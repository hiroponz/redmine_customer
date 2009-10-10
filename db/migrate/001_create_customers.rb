# Use rake db:migrate_plugins to migrate installed plugins
class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.column :name, :string
      t.column :address, :text
      t.column :neighborhood, :text
      t.column :number, :string
      t.column :residential_phone, :string
      t.column :mobile_phone, :string
      t.column :email, :string
      t.column :birthday, :date
      t.column :cpf, :string
      t.column :rg, :string
      t.column :rg_expeditor, :string
      t.column :gender, :string
      t.column :favorite_contact, :string
    end
  end

  def self.down
    drop_table :customers
  end
end
