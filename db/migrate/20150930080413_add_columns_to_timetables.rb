class AddColumnsToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :day2, :string
    add_column :timetables, :size, :integer
  end
end
