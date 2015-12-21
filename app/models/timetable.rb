class Timetable < ActiveRecord::Base
	belongs_to :user
	has_many :enrollments, dependent: :destroy
end
