class Note < ActiveRecord::Base
  
  def status
    return :active if self.outcome.nil?
    self.outcome ? :finished : :cancelled
  end
end
