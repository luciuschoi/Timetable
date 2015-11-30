class StaticPagesController < ApplicationController
   before_action :fillnickname, only: [:home]
   before_action :gohome, only: [:daemoon]
   before_action :goforcingwritting, only:[:home, :newsfeed]
  def home
    if params[:search]
      if !params[:major].nil? && !params[:major].include?('모든학과')
        @lectures = Lecture.search_home(params[:search]).where(:major =>params[:major]).order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
      else 
       @lectures = Lecture.search_home(params[:search]).order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )
      end 
    elsif !params[:major].nil? && !params[:major].include?('모든학과')
      @lectures = Lecture.where(:major =>params[:major]).
      order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
    end      
  end

  def newsfeed

    if !params[:major].nil? && !params[:major].include?('모든학과')
      @valuations = Valuation.join_major.where("major = ?", params[:major]).
      order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
      @major_name = params[:major]
      @count_of_today = 0
      
      @valuations.each do |v|
        difference = Time.zone.now - v.created_at 
        if difference < 86400 && difference > 0
          @count_of_today += 1
        end
      end


      respond_to do |format|
        format.js
        format.html {redirect_to newsfeed_path}
      end
    else
      @valuations=Valuation.order("created_at DESC").paginate(:page => params[:page], :per_page =>10)
      @count_of_today = 0
      @major_name = '전체학과'
      @valuations.each do |v|
        difference = Time.zone.now - v.created_at 
        if difference < 86400 && difference > 0
          @count_of_today += 1 
        end
      end
    end

  end 

  def rank
  
    if params[:search]==''||params[:search].nil?
    else
     
        @lectures = Lecture.search_timetable(params[:search]).paginate(:page => params[:page], :per_page => 10)
   
    end
    @lectures_in_timetable = current_user.timetables
  end
    
  def propose
    @decimal_arr = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.3, 0.2, 0.5]
    @decimal_arr.shuffle!

    lec = Lecture.where("acc_total between 3.5 and 5 and major LIKE '컴퓨터공학과'")
    lec_len = lec.length
    @lec_arr = []

    seed_value = [1,2,3,4,5,6,7,8,9,10]
    prng = Random.new(seed_value.shuffle![0])
    
    for value in 0..9
      ran_num = prng.rand(0..lec_len)
      @lec_arr.push(lec[ran_num])
    end

    respond_to do |format|
        format.js
        format.html {redirect_to rank_path}
    end
  end

  def menual
    @menual_num
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end

  def daemoon
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end 

  def first_login
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end


  def forcingwritting
    if params[:search]

      if !params[:major].nil? && !params[:major].include?('모든학과')


      @lectures = Lecture.search(params[:search]).where(:major =>params[:major]).order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
           
      else 
       @lectures = Lecture.search(params[:search]).paginate(:page => params[:page], :per_page => 10 )
      end 
    elsif !params[:major].nil? && !params[:major].include?('모든학과')
      @lectures = Lecture.where(:major =>params[:major]).
      order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
    else 

     # @lectures=Lecture.all.order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )
       @lectures=Lecture.search('asgreagjergoierjiogjerigjeriogj').order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )

    end
  end

  def forcinglogin
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end

  def home_admin
    if current_user.admin?
      @lectures=Lecture.all.paginate(:page => params[:page], :per_page => 10 )
    else
      redirect_to root_url
    end
  end


  def search
    @lectures = Lecture.where('major = ?', params[:lecture_name])
    render '_home_user'    
  end

 private 

  def goforcingwritting
      if current_user.valuations.count<1
        redirect_to forcingwritting_path
      end 
  end

  def fillnickname 
     if logged_in_user? && current_user.nickname.nil?
        flash[:danger]= "닉네임을 설정하여 주세요. 익명성 보장을 위함입니다."
        redirect_to edit_user_url(current_user)
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