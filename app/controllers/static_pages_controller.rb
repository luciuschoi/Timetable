class StaticPagesController < ApplicationController
   before_action :fillnickname, only: [:home]
   before_action :login_check, only:[:forcingwritting]
  def home

    # 검색 했니?
  	if !params[:search].nil?
  	  @lectures=Lecture.search(params[:search_from],
                                params[:search]).paginate(:page => params[:page], :per_page => 10 )
    # 검색 안하고 학과 선택했니 ?
    elsif !params[:lecture_name].nil? && !params[:lecture_name].include?('모든학과')
      @valuations = Valuation.join_major.where("major = ?", params[:lecture_name])

      respond_to do |format|
        format.js
        format.html #{redirect_to @valuations}
      end

  	else
      @valuations=Valuation.order("created_at DESC").limit(10)
  	end

#    respond_to do |format|
#       format.js
#       format.html # home.html.erb
#    end
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

  end



  def user_login?
      if(session[:user_id].nil?&&session[:user_name].nil?)
          false
      else 
          true
     end
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

  def login_check
    unless user_login?
        redirect_to root_url
    end

  end
  
end