class Change < ActiveRecord::Base
  belongs_to :note
  belongs_to :user

  @@sense_values = [ :created, :finished, :cancelled, :accepted, :rejected, :assigned, :commented, :set_priority, :set_status ]

  def sense
     self.meaning.nil? ? nil : @@sense_values[self.meaning]
  end

  def sense= sym
    self.meaning = sym.nil? ? nil : @@sense_values.index( sym )
  end
  
end
