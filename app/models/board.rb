class Board < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  has_many :user_privs, :dependent => :destroy

end
