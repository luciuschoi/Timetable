class StaticPagesController < ApplicationController
  def home
  	if params[:search].nil?
  		@lectures=Lecture.paginate(:page => params[:page], :per_page => 20 )
  	#@lectures=Lecture.paginate(:per_page =>20, :page => params[:page])
  	else
  	@lectures=Lecture.search(params[:search])
  	end
  end
end
