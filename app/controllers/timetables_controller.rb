class TimetablesController < ApplicationController
	def timetable
		if params[:search]==''||params[:search].nil?

	    else
	        @lectures = Lecture.search_timetable(params[:search]).paginate(:page => params[:page], :per_page => 10)
	    end
	    # 시간표에 강의 등록한 사용자
	    if (t = current_user.timetables.find(params[:id]))

	      # 기본 타임테이블(0번 인덱스) 안에 등록된 강의 collection 담기
	      @lectures_in_timetable = t.enrollments  

	      activated_timetable(t)
	      # 유저가 생성한 타임테이블 collection 
	      @timetables = current_user.timetables
	    
	    # 강의 등록한 적 없는 사용자
	    else
	      current_user.timetables.create!(name: "기본시간표")
	      @lectures_in_timetable = current_user.timetables[0].enrollments  
	    end
	end

	def create
		current_user.timetables.create!(name: "기본시간표")

		redirect_to timetable_path
	end
end
