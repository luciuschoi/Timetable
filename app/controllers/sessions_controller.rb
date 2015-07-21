class SessionsController < ApplicationController

	def create
	    user = User.from_omniauth(env["omniauth.auth"])
        session[:user_id] = user.id 
        session[:user_name] = user.name

        if user.nickname.nil?
          redirect_to :controller => 'users', :action => 'edit', :id => user.id
        else
          redirect_to root_path
        end
      
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
