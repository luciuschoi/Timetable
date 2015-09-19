class StaticPagesController < ApplicationController
   before_action :fillnickname, only: [:home]
   before_action :gohome, only: [:daemoon]
  def home
    if params[:search]
  	   @lectures = Lecture.search(params[:search]).paginate(:page => params[:page], :per_page => 10 )
    end
  end

  def newsfeed
    if !params[:lecture_name].nil? && !params[:lecture_name].include?('모든학과')
      @valuations = Valuation.join_major.where("major = ?", params[:lecture_name]).
      order("created_at DESC").paginate(:page => params[:page], :per_page =>10)

      respond_to do |format|
        format.js
        format.html {redirect_to newsfeed_path}
      end
    else
      @valuations=Valuation.order("created_at DESC").paginate(:page => params[:page], :per_page =>10)
    end

  end 

  def menual
    @menual_num
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !


  end

  def login_form

  end

  def daemoon
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end 


  def forcingwritting
    if !params[:search].nil?
      @lectures=Lecture.search(params[:search]).paginate(:page => params[:page], :per_page => 10 )

    else 
      @lectures=Lecture.all.paginate(:page => params[:page], :per_page => 10 )
    end
  end

  def forcinglogin

    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end





  def search
    @lectures = Lecture.where('major = ?', params[:lecture_name])
    render '_home_user'    
  end

 private 

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
  def user_login?
    if session[:user_id].nil? && session[:user_name].nil?
        false
    else 
        true
    end
  end

  def gohome
    if user_login?
      redirect_to home_path
    end
  end
  
  
end