class Timetable < ActiveRecord::Base
	has_many :lectures
	belongs_to :user
	#validates :subject, :uniqueness => true
	#validates_uniqueness_of :subject
	serialize :days, Array
	validates :lecture_id, :uniqueness => true
end