class CreateChanges < ActiveRecord::Migration
  def self.up
    create_table :changes do |t|
      t.integer :note_id, :null => false
      t.integer :user_id, :null => false
      t.integer :meaning, :null => false
      t.integer :argument, :null => true
      t.text :comment, :null => true
      t.timestamp :created
    end

    add_index :changes, :note_id
    add_index :changes, :created

  end

  def self.down
    drop_table :changes
  end
end
