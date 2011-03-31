class UserPriv < ActiveRecord::Base
  belongs_to :user
  belongs_to :privilege
  #belongs_to :board
end
