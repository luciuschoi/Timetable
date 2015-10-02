class Timetable < ActiveRecord::Base
	has_many :lectures
	belongs_to :user
	validates :subject, :uniqueness => true
end