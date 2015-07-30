 class LecturesController < ApplicationController
	before_action :admin_user, only: [:destroy, :edit, :create, :update, :new, :import]
	require 'roo'
	
	def show
		@lecture = Lecture.find_by(id: params[:id])
		@AnotherProfessors = Lecture.where("subject = ?", @lecture.subject)
		@AnotherSubjects = Lecture.where("professor = ?", @lecture.professor)
		#@comment = current_user.comments.build
		@comments = Comment.where("lecture_id = ?", @lecture.id).order('created_at DESC')
		
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

	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
