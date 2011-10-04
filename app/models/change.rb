class Change < ActiveRecord::Base
  belongs_to :note
  belongs_to :user

  @@sense_values = [ :created, :finished, :cancelled, :accepted, :rejected, :assigned, 
    :commented, :raise_priority, :lower_priority, :start_work, :stop_work, 
    :set_problem, :reset_problem, :unassigned, :edited_title, :edited_content, 
    :attachement, :set_date, :set_time, :reset_date, :reset_time, :board_changed ]

  def sense
     self.meaning.nil? ? nil : @@sense_values[self.meaning]
  end

  def sense= sym
    self.meaning = sym.nil? ? nil : @@sense_values.index( sym )
  end
  
end
