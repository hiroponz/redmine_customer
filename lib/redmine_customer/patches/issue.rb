module RedmineCustomer
  module Patches
    module Issue
      def self.included(base)
        base.class_eval do
          unloadable
          belongs_to :customer
          ::Issue::SAFE_ATTRIBUTES << 'customer_id' if Issue.const_defined? "SAFE_ATTRIBUTES"
        end
      end
    end
  end
end
