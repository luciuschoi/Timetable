class UsersController < ApplicationController
  def edit 
  	@user = User.find_by(id: params[:id])
  end


  def update
  	@user=User.find(params[:id])
  	if @user.update_attributes(nick_params)
  		redirect_to root_path
  	else 
  		flash.now[:danger]=@user.errors.full_messages
  		render 'edit'
  	end
  end

  def nick_params
  	params.require(:user).permit(:nickname)
  end
end

