class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  before_action :admin_user, only: :destroy
  
  def index
    if current_user.admin?
      @users = User.paginate(page: params[:page])
    else
      redirect_to root_url
    end
  end  

  def edit 
  	@user = User.find_by(id: params[:id])
  end

  def update
  	@user=User.find(params[:id])
  	if @user.update_attributes(nick_params)
        if @user.valuations.count > 2
  		      redirect_to root_path
        else
            redirect_to :controller => 'static_pages', :action => 'forcingwritting'
        end    
  	else 
    		flash.now[:danger]=@user.errors.full_messages
    		render 'edit'
    	end
  end

  private 
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
    def correct_user 
      @user = User.find(params[:id])
      unless current_user?(@user) 
          flash[:danger]="Invalid access!"
          redirect_to root_path
      end
    end

    def nick_params
    	params.require(:user).permit(:nickname)
    end
end

