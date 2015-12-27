class TimetablesController < ApplicationController
	def timetable
		if params[:search]==''||params[:search].nil?

	    else
	        @lectures = Lecture.search_timetable(params[:search]).paginate(:page => params[:page], :per_page => 10)
	    end
	    # 시간표에 강의 등록한 사용자
	    if (@current_timetable = current_user.timetables.find(params[:id]))

			# 기본 타임테이블(0번 인덱스) 안에 등록된 강의 collection 담기
			@lectures_in_timetable = @current_timetable.enrollments  

			# activated_timetable(t)
			
			@timetables = current_user.timetables
	      	
	    # 강의 등록한 적 없는 사용자
	    else
	      current_user.timetables.create!(name: "기본시간표")
	      @lectures_in_timetable = current_user.timetables[0].enrollments  
	    end
	end

	def new
		@timetable = Timetable.new
	end

	def create
		@timetable = current_user.timetables.create!(timetable_params)

		redirect_to timetable_path(@timetable)
	end

	def destroy
		timetable = current_user.timetables.find(params[:id])
		timetable.destroy

		redirect_to home_path
	end
	def detailsearch
		render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
	end
	private 
	def timetable_params
		params.require(:timetable).permit(:name)
	end
end
