class TimetablesController < ApplicationController
	def show
		
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

	def edit
		@timetable = Timetable.find_by(id: params[:id])
	end

	def update
		@timetable = Timetable.find(params[:id])
		if !params[:timetable][:name].nil?
			@timetable.update_attribute(:name, params[:timetable][:name])
			redirect_to timetable_path(@timetable)
		else
			render 'edit'
		end
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


	def copy
		@existed_timetable = Timetable.find(params[:id])
	end

	def paste
		@existed_t = Timetable.find(params[:timetable][:id])
		
		#복제시 이름 같이 업데이트, 그래서 이름값 인자로 같이 보냄 
		@reproduced_t = reproduce_timetable(@existed_t, params[:timetable][:name])
		reproduce_enrollment(@existed_t, @reproduced_t)

		redirect_to timetable_path(@reproduced_t)
	end

	def detailsearch
		render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
	end

	private 

	def timetable_params
		params.require(:timetable).permit(:name)
	end







end
