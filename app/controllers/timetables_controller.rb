class TimetablesController < ApplicationController
	def create
		@request_lecture = current_user.timetables.build(timetable_params)
		@request_lecture.save!

		respond_to do |format|
			format.js
			format.html {redirect_to rank_path}
		end
	end


	def destroy 
		@timetable = Timetable.find_by(lecture_id: params[:lecture_id])
		@timetable.destroy

		respond_to do |format|
			format.js
			format.html {redirect_to rank_path}
		end
	end

	def search_timetable
		@lectures = Lecture.search(params[:search])
		# render 'timetables/_searched_lecture_table', :lectures => @lectures
		# redirect_to rank_path (@lectures)
		respond_to do |format|
			format.js
			format.html {redirect_to rank_path}
		end
	end

	private

    def timetable_params
    	params.permit(:begin_time, :end_time, {:days => []}, :lecture_id)
    end

    # def subject_and_professor_name_existed?
    # 	# 등록한 강의가 1개 이상이니?
    # 	if self.
    # end










end 	