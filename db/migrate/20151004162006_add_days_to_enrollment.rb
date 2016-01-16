class AddDaysToTimetable < ActiveRecord::Migration
  def change
  	add_column :timetables, :days, :string
  end
end
