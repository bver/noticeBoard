class User < ActiveRecord::Base
  has_many :permissions, :dependent => :destroy
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
      return [:view_board, :process_notes].include?( name ) if self.id.nil?
      perm = self.permissions.detect { |p| board_id == p.board_id }
      perm = Permission.find_by_user_id_and_board_id( self.id, board_id ) if perm.nil?
      perm.privilege? name
  end

  def grant( name, board_id = nil )
      perm = self.permissions.detect { |p| board_id == p.board_id }
      perm.grant name
      perm.save
  end

  def revoke( name, board_id = nil )
      perm = self.permissions.detect { |p| board_id == p.board_id }
      perm.revoke name
      perm.save
  end

  def ensure_permissions board_id=nil
     perm = self.permissions.detect { |p| p.board_id == board_id }
     perm = Permission.find_by_user_id_and_board_id( self.id, board_id ) if perm.nil?
     return unless perm.nil?

     perm = Permission.new :user_id => self.id, :board_id => board_id
     if board_id.nil?
          perm.reset # user default - zeroes
     else 
          src = self.permissions.detect { |p| p.board_id.nil? }
          src = Permission.find_by_user_id_and_board_id( self.id, nil ) if src.nil?
          perm.values = src.values.clone  # board-specific default
     end
     perm.save
     self.permissions << perm
  end

end
