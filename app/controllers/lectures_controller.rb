class LecturesController < ApplicationController
   before_action :admin_user, only: [:destroy, :edit, :create, :update, :new, :import]
   before_action :fillnickname, only: [:show]
   before_action :correct_user, only: [:timetable]
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
       major: params[:lecture][:major], lecturetime: params[:lecture][:lecturetime])
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


  def timetable

   if params[:search].nil?
    @lectures=Lecture.paginate(:page => params[:page], :per_page => 10 )
     #@lectures=Lecture.paginate(:per_page =>20, :page => params[:page])
   else
    @lectures=Lecture.search(params[:search_from],params[:search]).paginate(:page => params[:page], :per_page => 10 )
  end

  respond_to do |format|
   format.js
       format.html # timetable.html.erb

     end

   end 





  private
  def lecture_params
    params.require(:lecture).permit(:subject, :professor, :major, :lecturetime)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def fillnickname 
    if logged_in_user? && current_user.nickname.nil?
     flash[:danger]= "닉네임을 설정하여 주세요. 익명성 보장을 위함입니다."
     redirect_to edit_user_url(current_user)
    end
  end

end