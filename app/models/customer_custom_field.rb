class CustomerCustomField < CustomField
  def type
    self.class
  end

  def type_name
    :label_customer_plural
  end
end

