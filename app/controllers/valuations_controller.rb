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




















