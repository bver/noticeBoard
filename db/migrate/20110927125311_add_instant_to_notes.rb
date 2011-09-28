class AddInstantToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :instant_date, :date, :default => nil
    add_column :notes, :instant_time, :time, :default => nil
    add_index :notes, :instant_date
    add_index :notes, :instant_time
  end

  def self.down
     remove_column :notes, :instant
     remove_column :notes, :instant_type
  end
end
