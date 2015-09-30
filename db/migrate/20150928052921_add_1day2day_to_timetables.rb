class Add1day2dayToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :howoften, :integer
  end
end
