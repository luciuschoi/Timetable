class ValuationsController < ApplicationController
	
	def create
	
		
		
		
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

			@lecture.save!

		


    end



end


