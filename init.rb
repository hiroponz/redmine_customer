# Redmine customer plugin
require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'

# Dependências
require_dependency 'issue'
require_dependency 'project'
require_dependency 'query'
require_dependency 'custom_value'
require_dependency 'customer_issue_hook'
require_dependency 'custom_fields_helper'

require 'redmine_customer'

Dispatcher.to_prepare do
  Issue.send(:include, RedmineCustomer::Patches::Issue)
  Project.send(:include, RedmineCustomer::Patches::Project)
  Query.send(:include, RedmineCustomer::Patches::Query)
  CustomValue.send(:include, RedmineCustomer::Patches::CustomValue)
  ApplicationController.send(:include, RedmineCustomer::Patches::ApplicationController)
  CustomFieldsHelper.send(:include, RedmineCustomer::Patches::CustomFieldsHelper)
end

RAILS_DEFAULT_LOGGER.info 'Starting Redmine Customer plugin'

Redmine::Plugin.register :redmine_customer do
  name 'Redmine Customer plugin'
  author 'Hiroyuki Sato'
  description 'This is a plugin for Redmine that can be used to track basic customer information'
  version '0.3.0'
  requires_redmine :version_or_higher => '0.9.0'

  url 'http://hiroponz.net/redmine/projects/priw' if respond_to? :url
  author_url 'http://hiroponz.net/redmine/projects/priw' if respond_to? :author_url

  project_module 'customer' do
    permission :manage_customers, :customers => [:new, :create, :edit, :update, :destroy]
    permission :view_customers, :customers => [:index, :show, :autocomplete, :mail], :public => true
  end

  menu(
    :project_menu,
    :customers,
    {:controller => 'customers', :action => 'index'},
    :caption => :customer,
    :param => :project_id,
    :after => :files
  )
end
