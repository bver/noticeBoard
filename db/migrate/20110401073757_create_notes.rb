class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :board_id, :null =>false
      t.integer :user_id, :null=> true, :default => nil
      t.string :title, :null=> false
      t.integer :priority, :null => false, :default => 1
      t.boolean :outcome, :null=> true, :default => nil
      t.boolean :working, :null => false, :default => false
      t.boolean :problem, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
