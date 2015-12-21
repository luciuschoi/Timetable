class AddUseridToTimetables < ActiveRecord::Migration
  def change
    add_column :timetables, :user_id, :integer
  end
end
