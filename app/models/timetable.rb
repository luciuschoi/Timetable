class Timetable < ActiveRecord::Base
	has_many :lectures, dependent: :destroy
	belongs_to :user


end