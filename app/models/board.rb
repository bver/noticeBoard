class Board < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  has_many :user_privs, :dependent => :destroy

  validates_length_of :title, :minimum=> 3,  :maximum=>20
  validates_uniqueness_of :title
end
