class AddNeighborhoodIdToCustomers < ActiveRecord::Migration
  def self.up
    remove_column :customers, :neighborhood
    add_column :customers, :neighborhood_id, :integer
  end

  def self.down
    remove_column :customers, :neighborhood
    add_column :customers, :neighborhood, :string
  end
end
