class AddEvaluationsToLectures < ActiveRecord::Migration
  def change

    add_column :lectures, :acc_grade, :integer, default: 0
    add_column :lectures, :acc_workload, :integer, default: 0
    add_column :lectures, :acc_level, :integer, default: 0
    add_column :lectures, :acc_achievement, :integer, default: 0
    add_column :lectures, :acc_total, :integer, default: 0
  end
end
