class SessionsController < ApplicationController

	def create
	user = User.new
    user = User.omniauth(user_params)
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
  end

private
  def user_params
  	params.require(:user).permit(:provider, :uid, :name, :oauth_token, :oauth_expires_at)
  	  end

end
