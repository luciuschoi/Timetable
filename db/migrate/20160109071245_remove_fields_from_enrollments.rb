class RemoveFieldsFromEnrollments < ActiveRecord::Migration
  def change
  	remove_column :enrollments, :howoften
  	remove_column :enrollments, :day2
  	remove_column :enrollments, :size
  	remove_column :enrollments, :table_num
  	remove_column :enrollments, :subject
  end
end