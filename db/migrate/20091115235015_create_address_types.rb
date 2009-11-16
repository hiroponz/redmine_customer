class CreateAddressTypes < ActiveRecord::Migration
  def self.up
    create_table :address_types do |t|
      t.column :name, :string
    end

    add_column :customers, :address_type_id, :integer
  end

  def self.down
    drop_table :address_types
  end
end
