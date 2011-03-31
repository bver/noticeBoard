class Privilege < ActiveRecord::Base
  has_many :user_privs
  has_many :users, :through => :user_privs
end
