require_dependency 'project'

module ProjectPatch
  def self.included(base)
    base.class_eval do
      has_many :customers
    end
  end
end
