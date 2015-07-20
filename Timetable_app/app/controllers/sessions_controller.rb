class SessionsController < ApplicationController

	def create
	    user = User.from_omniauth(env["omniauth.auth"])
        session[:user_id] = user.id 
        session[:user_name] = user.name
        

      redirect_to root_path
      
  end

  def destroy
  
    session[:user_id] = nil
    session[:user_name] = nil

    redirect_to root_path
  end

private
  def user_params
  	params.require(:user).permit(:provider, :uid, :name, :oauth_token, :oauth_expires_at)
  	  end

end
