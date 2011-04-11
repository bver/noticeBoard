class Note < ActiveRecord::Base
  belongs_to :board
  belongs_to :user
  has_many :changes, :dependent => :destroy

  validates_length_of :title, :minimum=> 3,  :maximum=>40
  
  def status
    return :active if self.outcome.nil?
    self.outcome ? :finished : :cancelled
  end

  def status=sym
    self.outcome = Note.status2outcome sym
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
