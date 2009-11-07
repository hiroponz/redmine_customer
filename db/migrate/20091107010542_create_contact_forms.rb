class CreateContactForms < ActiveRecord::Migration
  def self.up
    create_table :contact_forms do |t|
      t.column :name, :string
    end

    create_table :contact_forms_customers, :id => false do |t|
      t.references :contact_form
      t.references :customer
    end
  end

  def self.down
    drop_table :contact_forms
    drop_table :contact_forms_customers
  end
end
