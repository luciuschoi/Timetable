class ValuationsController < ApplicationController
	def create
		@lecture = Lecture.find(params[:lecture_id])

		# 해당 강의에 대해 현재 유저가 평가 한적 있는지 검사
		if current_user.valuations.find_by(lecture_id: @lecture.id)
			render 'lectures/show'
		else
			@lecture.lec_grade(params[:grade])  #해당 강의 grade 별점 누적 
			current_user.evaluated_grade        #해당 유저가 몇점을 주었는지 기록..형근데 여기부분은 생각해보니 했는지 안했는지만 하면되지않나염?
			#@lecture.lec_workload(params[:workload])
			#current_user.evaluated_workload
			#@lecture.lec_achievement(params[:achivement])
			#current_user.evaluated_achievement
			#@lecture.lec_level(params[:level])
			#current_user.evaluated_level
			#@lecture.lec_total(params[:total])
			#current_user.evaluated_total
		end

		@lecture.save!

		respond_to do |format|
			format.html {redirect_to @lecture}
			format.js
		end
	end
end




















