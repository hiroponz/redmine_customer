class CreateNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :neighborhoods
  end
end
