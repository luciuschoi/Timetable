class RenameTimetablesToEnrollments < ActiveRecord::Migration
  def change
  	rename_table :timetables, :enrollments
  end
end
