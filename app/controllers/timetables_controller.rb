class TimetablesController < ApplicationController
	skip_before_action :verify_authenticity_token
	def create 
		lec = Lecture.where(subject: params[:lecture_subject],
		 professor: params[:lecture_professor], lecturetime: params[:lecture_time]).first
		if params[:day2].nil?
			@timetable=current_user.timetables.build(day: params[:day],begin_time:params[:begin_time],
			end_time:params[:end_time],table_num:params[:table_num],howoften:params[:howoften],
			size:params[:size], user_id:current_user.id, lecture_id:lec.id, subject: params[:lecture_subject])

		else
			@timetable=current_user.timetables.build(day: params[:day], day2: params[:day2],begin_time:params[:begin_time],
			end_time:params[:end_time],table_num:params[:table_num],howoften:params[:howoften], subject: params[:lecture_subject],
			size:params[:size], user_id:current_user.id, lecture_id:lec.id)
		end
		@timetable.save!
		redirect_to timetable_user_path(current_user.id)

	end

	def update
	end
	def destroy
		@Timetable_to_delete=Timetable.where('subject= ? AND user_id= ?',params[:lecture_subject], current_user.id).first 
	
		@Timetable_to_delete.destroy

		redirect_to timetable_user_path(current_user.id)
	end
	def edit
	end

	def make_a_change
		lec_id = Lecture.where('subject = ? AND professor = ?',params[:lecture_subject],params[:lecture_professor]).first
		@timetable_to_delete = Timetable.where('lecture_id = ? AND user_id=? ', 
		lec_id.id, current_user.id).first
		size=@timetable_to_delete.size
		day=@timetable_to_delete.day
		begin_time=@timetable_to_delete.begin_time
		
		redirect_to timetable_user_path(current_user.id, size: size, )

	end
end 	