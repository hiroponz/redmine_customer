class AddContactFormsCacheToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :contact_forms_cache, :string
  end

  def self.down
    remove_column :customers, :contact_forms_cache
  end
end
