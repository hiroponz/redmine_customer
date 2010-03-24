# Redmine customer plugin
require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'

# Dependências
require_dependency 'issue'
require_dependency 'project'
require_dependency 'customer_issue_hook'
require_dependency 'query'
require_dependency 'custom_fields_helper'

require 'brcpfcnpj'
require 'customer_plugin'

Dispatcher.to_prepare do
  Issue.send(:include, CustomerPlugin::Patches::Issue)
  Project.send(:include, CustomerPlugin::Patches::Project)
  Query.send(:include, CustomerPlugin::Patches::Query)
  ApplicationController.send(:include, CustomerPlugin::Patches::ApplicationController)
  CustomFieldsHelper.send(:include, CustomerPlugin::Patches::CustomFieldsHelper)
end

RAILS_DEFAULT_LOGGER.info 'Starting Customer plugin for RedMine'

Redmine::Plugin.register 'customer-plugin' do
  name 'Customer plugin'
  author 'Eric Davis'
  description 'This is a plugin for Redmine that can be used to track basic customer information'
  version '0.2.0'

  url 'https://projects.littlestreamsoftware.com/projects/redmine-customers' if respond_to? :url
  author_url 'http://www.littlestreamsoftware.com' if respond_to? :author_url

  project_module 'customer-plugin' do
    permission :manage_customers, :customers => [:new, :create, :edit, :update, :destroy]
    permission :view_customers, :customers => [:index, :show], :public => true
  end

  menu :project_menu, :customers, {:controller => 'customers', :action => 'index'}, :caption => :customer_title, :param => :project_id, :after => :files
end
