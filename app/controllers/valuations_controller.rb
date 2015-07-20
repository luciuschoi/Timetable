class ValuationsController < ApplicationController
	def create

		@lecture = Lecture.find(params[:lecture_id])


		if current_user.valuations.find_by(lecture_id: @lecture.id)
			if params[:uptachi]
 
				@lecture.lec_uptachi
				@lecture.hatachi -= 1
				current_user.revaluated(@lecture, 1)
			elsif params[:hatachi]
				@lecture.lec_hatachi
				@lecture.uptachi -= 1
				current_user.revaluated(@lecture, 2)
			end
			@lecture.save!
		else
			if params[:uptachi]
				@lecture.lec_uptachi
				current_user.evaluated(@lecture, 1)

			elsif params[:hatachi]

				@lecture.lec_hatachi
				current_user.evaluated(@lecture, 2)

			else
				render 'lectures/show'
			end

			@lecture.save
		end
		
		redirect_to @lecture
#		respond_to do |format|
#			format.html {redirect_to @lecture}
#			format.js
#		end
	end
end
