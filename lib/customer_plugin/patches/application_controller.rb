module CustomerPlugin
  module Patches
    module ApplicationController
      def current_user
        User.current
      end
    end
  end
end

