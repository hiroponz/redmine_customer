# Use rake db:migrate_plugins to migrate installed plugins
class UnlinkCustomersToProjects < ActiveRecord::Migration
  def self.up
    remove_column :customers, :project_id
  end

  def self.down
    add_column :customers, :project_id, :integer
  end
end
