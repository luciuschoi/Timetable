class AddSubjectToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :subject, :string
  end
end
