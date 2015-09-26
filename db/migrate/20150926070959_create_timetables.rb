class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.string :day
      t.string :begin_time
      t.string :end_time
      t.int :table_num

      t.timestamps null: false
    end
  end
end
