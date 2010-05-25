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

RAILS_DEFAULT_LOGGER.info 'Starting Customer plugin for RedMine'

Redmine::Plugin.register :redmine_customer do
  name 'Customer plugin'
  author 'Eric Davis'
  description 'This is a plugin for Redmine that can be used to track basic customer information'
  version '0.2.0'
  requires_redmine :version_or_higher => '0.9.0'

  url 'https://projects.littlestreamsoftware.com/projects/redmine-customers' if respond_to? :url
  author_url 'http://www.littlestreamsoftware.com' if respond_to? :author_url

  project_module 'customer' do
    permission :manage_customers, :customers => [:new, :create, :edit, :update, :destroy]
    permission :view_customers, :customers => [:index, :show, :autocomplete, :mail], :public => true
  end

  settings :default => {:menu_caption => ''}, :partial => 'customers/settings'

  menu(
    :project_menu,
    :customers,
    {:controller => 'customers', :action => 'index'},
    :caption => lambda {
      Setting.plugin_redmine_customer[:menu_caption].present? ? Setting.plugin_redmine_customer[:menu_caption] : I18n.t(:customer)
    },
    :param => :project_id,
    :after => :files
  )
end
