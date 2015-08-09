class StaticPagesController < ApplicationController
  def home
  	if params[:search].nil?
  	  @lectures=Lecture.order_by_comments.group_by_id.paginate(:page => params[:page], :per_page => 10)
  	else
  		@lectures=Lecture.search(params[:search]).paginate(:page => params[:page], :per_page => 10 )
  	end
  end
end


