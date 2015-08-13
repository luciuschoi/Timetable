class StaticPagesController < ApplicationController
   before_action :fillnickname, only: [:home]
  def home

     if params[:search].nil?
       @lectures=Lecture.order_by_comments.group_by_id
     else
        @lectures=Lecture.search(params[:search_from],params[:search]).paginate(:page => params[:page], :per_page => 10 )
     end

  end
  def fillnickname 
     if logged_in_user? && current_user.nickname.nil?
        flash[:danger]= "닉네임을 설정하여 주세요. 익명성 보장을 위함입니다."
        redirect_to edit_user_url(current_user)
     end
  end
  
end