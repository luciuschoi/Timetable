class AddSemesterToTimetables < ActiveRecord::Migration
  def change
		add_column :timetables, :semester, :string, default: "1학기"
  end
end
