class AddArchiveSupportToBoard < ActiveRecord::Migration
  def self.up
    remove_column :boards, :active
    add_column  :boards, :visibility, :integer, :null => false, :default => 1
    # 0 .. hidden, 1 .. active, -1 .. archived
  end

  def self.down
    remove_column :boards, :visibility
    add_column :boards, :active, :boolean, :null => false, :default => true
  end
end
