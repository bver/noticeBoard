class CreateUserPrivs < ActiveRecord::Migration
  def self.up
    create_table :user_privs do |t|
      t.integer :user_id, :null => false
      t.integer :privilege_id, :null => false
      t.integer :board_id, :default => nil
    end

    add_index :user_privs, :user_id
    add_index :user_privs, :privilege_id
    add_index :user_privs, :board_id
  end

  def self.down
    drop_table :user_privs
  end
end
