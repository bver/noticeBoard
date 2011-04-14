class User < ActiveRecord::Base
  has_many :user_privs, :dependent => :destroy
  has_many :privileges, :through => :user_privs
  has_many :notes

  validates_length_of :name, :minimum=> 3,  :maximum=>20
  validates_uniqueness_of :name

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :name, :send_mails, :active

  ####
  
  def privilege?( name, board_id = nil )
      priv = Privilege.find_by_name!( name )
      glob = ! UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, nil ).nil?
      return glob if board_id.nil?
      spec = ! UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, board_id ).nil?
      return ! glob if spec
      glob
  end

  def grant( name, board_id = nil )
      priv = Privilege.find_by_name!( name )
      glob = UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, nil )
      if board_id.nil? # glob must be ensured
        UserPriv.delete_all( :privilege_id=>priv.id, :user_id=>self.id ) #remove specific negations
        UserPriv.create( :user_id => self.id, :privilege_id => priv.id, :board_id => nil ) # re-create glob
      else # specific, glob must be preserved
        spec = UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, board_id )
        if glob.nil?
          UserPriv.create( :user_id => self.id, :privilege_id => priv.id, :board_id => board_id ) if spec.nil?
        else
          spec.destroy unless spec.nil?
        end
      end
  end

  def revoke( name, board_id = nil )
      priv = Privilege.find_by_name!( name )
      glob = UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, nil )
      if board_id.nil? # glob (and all specs) must be removed
        UserPriv.delete_all( :privilege_id=>priv.id, :user_id=>self.id ) #remove glob& specs
      else # specific, glob must be preserved
        spec = UserPriv.find_by_user_id_and_privilege_id_and_board_id( self.id, priv.id, board_id )
        unless glob.nil?
          UserPriv.create( :user_id => self.id, :privilege_id => priv.id, :board_id => board_id ) if spec.nil? #ensure negation
        else
          spec.destroy unless spec.nil? # glob does not exist, ensure spec does not exist as well
        end
      end
  end

end
