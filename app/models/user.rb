class User < ActiveRecord::Base
  has_many :user_privs
  has_many :privileges, :through => :user_privs

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :name, :send_mails

  ####
  
  def privilege? name
      #(self.privileges.map {|priv| priv.name}).includes name.to_s
      priv = Privilege.find_by_name!(name)
      return false if priv.nil?
      not UserPriv.find_by_user_id_and_privilege_id( self.id, priv.id ).nil?
  end

  def grant name
      priv = Privilege.find_by_name!(name)
      g = UserPriv.find_by_user_id_and_privilege_id( self.id, priv.id )
      return unless g.nil?
      UserPriv.create( :user_id => self.id, :privilege_id => priv.id )
  end

  def revoke name
      priv = Privilege.find_by_name!(name)
      g = UserPriv.find_by_user_id_and_privilege_id( self.id, priv.id )
      return if g.nil?
      g.destroy
  end

  def list_privileges
    Privilege.all.map do |priv|
      g = UserPriv.find_by_user_id_and_privilege_id( self.id, priv.id )
      { :name => priv.name, :description => priv.description, :board => nil, :granted => !g.nil? }
    end
  end

end
