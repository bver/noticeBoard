class Note < ActiveRecord::Base
  belongs_to :board
  has_many :changes

  def status
    return :active if self.outcome.nil?
    self.outcome ? :finished : :cancelled
  end
end
