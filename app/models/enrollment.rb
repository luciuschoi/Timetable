class Enrollment < ActiveRecord::Base
	has_many :lectures
	# belongs_to :user
	belongs_to :timetable

	serialize :days, Array
	# validates :lecture_id, :uniqueness => true
end