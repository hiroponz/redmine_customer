module CustomerPlugin
  module Patches
    module Issue
      def self.included(base)
        base.class_eval do
          unloadable
          belongs_to :customer
        end
      end
    end
  end
end
