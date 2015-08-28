class ValuationsController < ApplicationController
	
	def create


		
		    @lecture= Lecture.find(params[:lecture_id])

			@lecture.lec_valuation(@lecture.valuations.count, params[:grade],params[:workload],params[:achievement],
			params[:level],params[:homework])  #해당 강의 grade 별점 누적 
			current_user.evaluated_valuation(@lecture,params[:grade],params[:workload],params[:achievement],
			params[:level],params[:homework],params[:total],params[:content])       
		  




			@lecture.save!

		
			

    end



end


