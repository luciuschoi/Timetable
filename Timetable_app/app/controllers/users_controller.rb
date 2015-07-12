class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
    @user=User.create(user_params)
    if @user.save
      
      render 'edit'
      sign_in(@user)
    else

      render 'new' 

    end 

  end

  def edit
    @user=User.find_by(id: params[:id])

  end


  def update  
    @user= User.find_by(id: params[:id])
    @user.update_attributes(user_nickname_params)
    redirect_to root_path
  end

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_nickname_params
    params.require(:user).permit(:nickname)
  end
end

