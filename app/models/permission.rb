class Permission < ActiveRecord::Base

  @@privs_user = [ :manage_users,  :add_boards,  :manage_boards,  :urgent_prio ]
  @@privs_board = [ :view_board, :edit_notes, :cancel_notes,  :assign_notes, :change_prio, :process_notes ]
  @@privs = @@privs_user + @@privs_board

  def reset
    values = ''
    @@privs.size.times { values += '0' }
    self.values = values
  end

  def privilege? priv
     reset if self.values.nil?
     i = @@privs.index priv
     raise ArgumentError if i.nil?
     self.values[i] == '1'
  end

  def grant priv
     reset if self.values.nil?
     i = @@privs.index priv
     raise ArgumentError if i.nil?
     val = self.values.clone
     val[i] = '1'
     self.values = val
   end

  def revoke priv
     reset if self.values.nil?
     i = @@privs.index priv
     raise ArgumentError if i.nil?
     val = self.values.clone
     val[i] = '0'
     self.values = val
  end

  def self.description sym
     "desc_#{sym}".intern
  end

  def self.privs_user
    @@privs_user
  end

  def self.privs_board
    @@privs_board
  end

  def self.privs
    @@privs
  end

end
