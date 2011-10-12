class DatetimeInstants < ActiveRecord::Migration
  def self.up
    change_column :notes, :instant_date, :datetime, :default => nil
    change_column :notes, :instant_time, :datetime, :default => nil
  end

  def self.down
    change_column :notes, :instant_date, :date, :default => nil
    change_column :notes, :instant_time, :time, :default => nil
  end
end
