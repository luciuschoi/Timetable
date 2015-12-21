class AddLectureidToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :lecture_id, :integer
  end
end
