class CreatePrivileges < ActiveRecord::Migration
  def self.up
    create_table :privileges do |t|
      t.string :name
      t.text :description
      t.boolean :board
    end

    add_index :privileges, :name,                :unique => true
  end

  def self.down
    drop_table :privileges
  end
end
