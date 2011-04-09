class Note < ActiveRecord::Base
  belongs_to :board
  has_many :changes, :dependent => :destroy

  validates_length_of :title, :minimum=> 3,  :maximum=>40
  
  def status
    return :active if self.outcome.nil?
    self.outcome ? :finished : :cancelled
  end

  def Note.status2outcome sym
    case sym.to_s[0].upcase
    when 'A'
      nil
    when 'F'
      true
    when 'C'
      false
    else
      raise ArgumentError
    end
  end
  
end
