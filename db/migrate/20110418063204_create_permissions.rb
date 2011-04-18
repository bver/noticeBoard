class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :user_id, :null => false
      t.integer :board_id, :default => nil
      t.string :values

      t.timestamps
    end

    add_index :permissions, :user_id
    add_index :permissions, :board_id
  end

  def self.down
    drop_table :permissions
  end
end
