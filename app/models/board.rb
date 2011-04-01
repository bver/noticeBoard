class Board < ActiveRecord::Base
  has_many :notes
  has_many :user_privs

end
