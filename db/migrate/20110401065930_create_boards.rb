class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.integer :user_id
      t.string :title, :null => false
      t.text :description
      t.boolean :active, :null => false, :default => true
      t.timestamps
    end

    add_index :boards, :active
  end

  def self.down
    drop_table :boards
  end
end
