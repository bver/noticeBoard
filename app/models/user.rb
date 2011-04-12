class User < ActiveRecord::Base
  has_many :user_privs, :dependent => :destroy
  has_many :privileges, :through => :user_privs

  validates_length_of :name, :minimum=> 3,  :maximum=>20
  validates_uniqueness_of :name

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :name, :send_mails

  ####
  
  def privilege?( name, board_id = nil )
      #(self.privileges.map {|priv| priv.name}).includes name.to_s
      priv = Privilege.find_by_name_and_board!( name, !board_id.nil? )
      return false if priv.nil?
      not UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, board_id ).nil?
  end

  def grant( name, board_id = nil )
      priv = Privilege.find_by_name_and_board!( name, !board_id.nil? )
      g = UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, board_id )
      return unless g.nil?
      UserPriv.create( :user_id => self.id, :privilege_id => priv.id, :board_id => board_id )
  end

  def revoke( name, board_id = nil )
      priv = Privilege.find_by_name_and_board!( name, !board_id.nil? )
      g = UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, board_id )
      return if g.nil?
      g.destroy
  end

#  def list_privileges
#    Privilege.all.map do |priv|
#      g = UserPriv.find_by_user_id_and_privilege_id( self.id, priv.id )
#      { :name => priv.name, :description => priv.description, :board => nil, :granted => !g.nil? }
#    end
#  end

  def User.guess_name_by_id id
     user = User.find(:first, id)
     user.nil? ? '???' : user.name
  end
end
