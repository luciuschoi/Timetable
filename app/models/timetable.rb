class Timetable < ActiveRecord::Base
	has_many :lectures
	belongs_to :user
	validates :day, uniqueness: {scope: [:begin_time, :end_time, :day2] }

end