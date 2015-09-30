class TimetablesController < ApplicationController
	skip_before_action :verify_authenticity_token
	def create 

		@TheLecture= Lecture.where(subject:params[:lecture_subject], professor: params[:lecture_professor]).first
		byebug
		lecture_id=@TheLecture.id
		@timetable=current_user.timetables.build(day: params[:day], begin_time:params[:begin_time],
			end_time:params[:end_time],table_num:params[:table_num],howoften:params[:howoften],
			size:params[:size],
			user_id:current_user.id, lecture_id:lecture_id)
		@timetable.save
		redirect_to timetable_user_path(current_user.id)
	end

	def update
	end
	def destroy
	end
	def edit
	end

	def make_a_change
		lec_id = Lecture.where('subject = ? AND professor = ?',params[:lecture_subject],params[:lecture_professor]).first
		@timetable_to_delete = Timetable.where('lecture_id = ? AND user_id=? ', 
		lec_id.id, current_user.id).first
		size=@timetable_to_delete.size;				
	
		redirect_to timetable_user_path(current_user.id, size: size)

	end
end 	