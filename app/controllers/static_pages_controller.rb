class StaticPagesController < ApplicationController
	before_action :fillnickname, only: [:home]
  def home
    # 검색 했니?
  	if !params[:search].nil?
  	  @lectures=Lecture.search(params[:search_from],
                                params[:search]).paginate(:page => params[:page], :per_page => 10 )
    # 검색 안하고 학과 선택했니 ?
    elsif !params[:lecture_name].nil? && !params[:lecture_name].include?('모든학과')
      @lecture_name = params[:lecture_name]
      lectures_of_major = Lecture.where('major = ?', @lecture_name)
      @lectures = lectures_of_major.order_by_comments.group_by_id
  	else
      @lectures=Lecture.order_by_comments.group_by_id
  	end
<<<<<<< HEAD
=======

  end

  def rank
    
  end


     


  def forcingwritting
    if !params[:search].nil?
      @lectures=Lecture.search(params[:search_from],
                                params[:search]).paginate(:page => params[:page], :per_page => 10 )
    
    end


  end

  def forcinglogin

    render(:layout => "layouts/showinglecture") #헤더파일 포함 안함 !
>>>>>>> parent of 675b053... 0825 강제강의평가페이지+ 강제세부강의평가페이지
  end

  def search
    @lectures = Lecture.where('major = ?', params[:lecture_name])

    render '_home_user'    
  end

  def fillnickname 
  	if logged_in_user? && current_user.nickname.nil?
  		flash[:danger]= "닉네임을 설정하여 주세요. 익명성 보장을 위함입니다."
  		redirect_to edit_user_url(current_user)
  	end
  end

  def home_admin
    if current_user.admin?
      @lectures=Lecture.paginate(:page => params[:page], :per_page => 20 )
    else
      redirect_to root_url
    end
  end
  
  
end
