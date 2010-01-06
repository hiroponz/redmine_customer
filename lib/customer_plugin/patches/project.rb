module CustomerPlugin
  module Patches
    module Project
      def self.included(base)
        base.class_eval do
          unloadable
          has_many :customers
        end
      end
    end
  end
end
