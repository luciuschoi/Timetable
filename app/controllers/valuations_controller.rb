class ValuationsController < ApplicationController
	def create
		@lecture = Lecture.find(params[:lecture_id])

		# 해당 강의에 대해 현재 유저가 평가 한적 있는지 검사
		if current_user.valuations.find_by(lecture_id: @lecture.id)
			render 'lectures/show'
		else
			if params[:uptachi]
				@lecture.lec_uptachi
				current_user.evaluated_up(@lecture, 1)

			elsif params[:hatachi]
				@lecture.lec_hatachi
				current_user.evaluated_down(@lecture, 1)
			else
				render 'lectures/show'
			end
		end

		@lecture.save!

		respond_to do |format|
			format.html {redirect_to @lecture}
			format.js
		end
	end
end








<<<<<<< HEAD

=======
	
		
		
		
		    @lecture= Lecture.find(params[:lecture_id])
			@lecture.lec_valuation(@lecture.valuations.count, params[:grade],params[:workload])  #해당 강의 grade 별점 누적 
			current_user.evaluated_valuation(@lecture,params[:grade],params[:workload])       


			#@lecture.lec_workload(params[:workload])
			#current_user.evaluated_workload
			#@lecture.lec_achievement(params[:achivement])
			#current_user.evaluated_achievement
			#@lecture.lec_level(params[:level])
			#current_user.evaluated_level
			#@lecture.lec_total(params[:total])
			#current_user.evaluated_total
>>>>>>> parent of 675b053... 0825 강제강의평가페이지+ 강제세부강의평가페이지











