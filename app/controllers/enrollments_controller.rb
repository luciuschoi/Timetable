class EnrollmentsController < ApplicationController
	def create
		@request_lecture = current_user.enrollments.build(enrollment_params)
		@request_lecture.save!


		lec = Lecture.find(params[:lecture_id])
		@place = lec.place

		respond_to do |format|
			format.js
			format.html {redirect_to rank_path}
		end
	end

	def destroy 
		@timetable = Enrollment.find_by(lecture_id: params[:lecture_id])
		@timetable.destroy

		respond_to do |format|
			format.js
			format.html {redirect_to rank_path}
		end
	end

	private

    def enrollment_params
    	params.permit(:begin_time, :end_time, {:days => []}, :lecture_id)
    end

    def time_validation

    end
    # def subject_and_professor_name_existed?
    # 	# 등록한 강의가 1개 이상이니?
    # 	if self.
    # end










end 	