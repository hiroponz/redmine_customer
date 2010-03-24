module CustomerPlugin
  module Patches
    module CustomValue
      def self.included(base)
        base.class_eval do
          alias_method_chain :validate, :cpf_cnpj_validation
        end
      end

      def  validate_with_cpf_cnpj_validation
        validate_without_cpf_cnpj_validation

        if custom_field.name =~ /cpf/i and custom_field.name =~ /cnpj/i
          errors.add(:value, :invalid_cpf_cnpj) unless Cpf.new(value).valido? or Cnpj.new(value).valido?
        end

        if custom_field.name =~ /cpf/i and not Cpf.new(value).valido?
          errors.add(:value, :invalid_cpf)
        end

        if custom_field.name =~ /cnpj/i and not Cnpj.new(value).valido?
          errors.add(:value, :invalid_cnpj)
        end
      end
    end
  end
end

