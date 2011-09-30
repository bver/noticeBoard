class CreateContexts < ActiveRecord::Migration
  def self.up

    create_table :contexts do |t|
      t.integer :user_id
      t.string :name
      t.boolean :active, :default => true, :nil => false

      t.timestamps
    end

    add_index :contexts, :user_id
    add_index :contexts, :active

    create_table :contexts_notes, :id => false do |t|
      t.integer :note_id
      t.integer :context_id
    end

    add_index :contexts_notes, :note_id
    add_index :contexts_notes, :context_id

  end

  def self.down
    drop_table :contexts
    drop_table :contexts_notes
  end
end
