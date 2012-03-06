class Board < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  has_many :permissions, :dependent => :destroy
  belongs_to :user

  validates_length_of :title, :minimum=> 3,  :maximum=>40
  validates_uniqueness_of :title

  attr_accessible :title, :description, :visibility

  # visibility values:
  Active = 1
  Hidden = 0
  Archived = -1
  
  def active
    self.visibility == Active
  end
  
end
