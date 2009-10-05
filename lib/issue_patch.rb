require_dependency 'issue'

# Patches Redmine's Issues dynamically.  Adds a relationship 
# Issue +belongs_to+ to Customer
module IssuePatch
  def self.included(base) # :nodoc:
    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      belongs_to :customer
    end
  end
end



