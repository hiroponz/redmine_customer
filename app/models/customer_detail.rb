require 'ostruct'

class CustomerDetail
  def initialize(attr, values)
    OpenStruct.new(
      :property => 'attr',
      :prop_key => attr,
      :old_value => values.first,
      :value => values.last
    )
  end
end
