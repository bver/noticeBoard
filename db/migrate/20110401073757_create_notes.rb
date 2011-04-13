class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :board_id, :null =>false
      t.integer :user_id, :null=> false, :default => -1
      t.string :title, :null=> false
      t.integer :priority, :null => false, :default => 1
      t.boolean :outcome, :null=> true, :default => nil
      t.boolean :working, :null => false, :default => false
      t.boolean :problem, :null => false, :default => false

      t.timestamps
    end

    add_index :notes, :board_id
    add_index :notes, :user_id
    add_index :notes, :priority
    add_index :notes, :outcome
    add_index :notes, :working
    add_index :notes, :problem
  end

  def self.down
    drop_table :notes
  end
end
