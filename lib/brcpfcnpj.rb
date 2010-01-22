%w(cpf_cnpj cnpj cpf cpf_cnpj_activerecord).each do |lib|
  require "brcpfcnpj/#{lib}"
end

%w(rubygems active_record activesupport).each do |lib|
  require lib
end

ActiveRecord::Base.send :include, CpfCnpjActiveRecord

module BrCpfCnpj
end

