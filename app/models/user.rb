class User < ActiveRecord::Base
  has_many :permissions, :dependent => :destroy
  has_many :notes
  has_many :contexts

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
      check_user_board( name, board_id )
      perm = self.permissions.detect { |p| board_id == p.board_id }
      perm = Permission.find_by_user_id_and_board_id( self.id, board_id ) if perm.nil?
      perm = Permission.new if perm.nil?
      perm.privilege? name
  end

  def grant( name, board_id = nil )
      check_user_board( name, board_id )
      ensure_permissions board_id
      perm = self.permissions.detect { |p| board_id == p.board_id }
      perm.grant name
      perm.save
  end

  def revoke( name, board_id = nil )
      check_user_board( name, board_id )
      ensure_permissions board_id
      perm = self.permissions.detect { |p| board_id == p.board_id }
      perm.revoke name
      perm.save
  end

  protected

  def check_user_board( name, board_id )
     return if board_id.nil?
     raise ArgumentError if Permission.privs_user.include? name
  end

  def ensure_permissions board_id=nil
     perm = self.permissions.detect { |p| p.board_id == board_id }
     perm = Permission.find_by_user_id_and_board_id( self.id, board_id ) if perm.nil?
     return unless perm.nil?

     perm = Permission.new :user_id => self.id, :board_id => board_id
     perm.reset # user default - zeroes
     perm.save
     
     self.permissions << perm
  end

end
