module RedmineCustomer
  module Patches
    module Project
      def self.included(base)
        base.class_eval do
          unloadable
          has_many :customer_members
          has_many :customers, :through=>:customer_members
        end
      end
    end
  end
end
