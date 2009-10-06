# Redmine customer plugin
require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'
require 'issue_patch'
require 'custom_fields_helper_patch'
Dispatcher.to_prepare do
  Issue.send(:include, IssuePatch)
  CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
end

# Hooks
require_dependency 'customer_issue_hook'

RAILS_DEFAULT_LOGGER.info 'Starting Customer plugin for RedMine'

Redmine::Plugin.register :customer_plugin do
  name 'Customer plugin'
  author 'Eric Davis'
  description 'This is a plugin for Redmine that can be used to track basic customer information'
  version '0.2.0'

  url 'https://projects.littlestreamsoftware.com/projects/redmine-customers' if respond_to? :url
  author_url 'http://www.littlestreamsoftware.com' if respond_to? :author_url

  menu :top_menu, :customers, {:controller => 'customers', :action => 'index'}, :caption => 'Customers'
end
