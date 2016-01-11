class RemoveFieldsFromLectures < ActiveRecord::Migration
  def change
  	  	remove_column :lectures, :uptachi
  	  	remove_column :lectures, :hatachi
  end
end
