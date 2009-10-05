# Use rake db:migrate_plugins to migrate installed plugins
class LinkCustomersToIssues < ActiveRecord::Migration
  def self.up
    add_column :issue, :customer_id, :integer    
  end

  def self.down
    remove_column :issues, :customer_id
  end
end
