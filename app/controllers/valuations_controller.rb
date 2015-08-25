class ValuationsController < ApplicationController
	
	def create

	
		
		
		
		    @lecture= Lecture.find(params[:lecture_id])
			@lecture.lec_valuation(@lecture.valuations.count, params[:grade],params[:workload],params[:achievement],
			params[:level],params[:total])  #해당 강의 grade 별점 누적 
			current_user.evaluated_valuation(@lecture,params[:grade],params[:workload],params[:achievement],
			params[:level],params[:total])       




			@lecture.save!

		


    end



end


