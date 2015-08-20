class AddEvaluationsToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :acc_grade, :integer
    add_column :lectures, :acc_workload, :integer
    add_column :lectures, :acc_level, :integer
    add_column :lectures, :acc_achievement, :integer
    add_column :lectures, :acc_total, :integer
  end
end
