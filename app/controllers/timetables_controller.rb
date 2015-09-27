class TimetablesController < ApplicationController
	skip_before_action :verify_authenticity_token
	def create 

		lecture_id= Lecture.where('subject=? AND professor=?',params[:lecture_subject],params[:lecture_professor]).pluck(:id)
		
		@timetable=current_user.timetables.build(day: params[:day], begin_time:params[:begin_time],
			end_time:params[:end_time],table_num:params[:table_num],user_id:current_user.id,lecture_id:lecture_id)
		@timetable.save
		
	end

	def update
	end
	def destroy
	end
	def edit
	end

end 	