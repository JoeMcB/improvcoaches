require "administrate/field/base"

module Administrate
  module Field
    class PasswordReset < Administrate::Field::Base
      def to_s
        "Password Reset"
      end
      
      # Override to not require an actual attribute on the model
      def self.permitted_attribute(attr, _options = nil)
        # Don't include in permitted params since it's not a real attribute
        nil
      end
    end
  end
end