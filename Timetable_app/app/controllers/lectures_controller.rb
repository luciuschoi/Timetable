class LecturesController < ApplicationController
	require 'roo'
	def show
		@lecture = Lecture.find_by(id: params[:id])
	end

	def edit
		@lecture = Lecture.find_by(id: params[:id])

	end

	def new
		@lecture = Lecture.new
	end

	def create
		
		Lecture.create(subject: params[:lecture][:subject], professor: params[:lecture][:professor], 
			major: params[:lecture][:major])
		redirect_to root_url
	end

	def update

		@lecture = Lecture.find_by(id: params[:id])
		if @lecture.update_attributes(lecture_params)
			redirect_to root_url
		else
			render 'edit'
		end
	end
	def destroy
		@lecture = Lecture.find_by(id: params[:id])
		@lecture.destroy
		redirect_to root_url
	end 

	def import
  Lecture.import(params[:file])
  redirect_to root_url, notice: "decorations imported."
    end

	
private
	def lecture_params
		params.require(:lecture).permit(:subject, :professor, :major)
	end
end
