class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path

    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

	def create_by_facebook
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
    log_out
    redirect_to root_url
  end



private
  def user_params
  	params.require(:user).permit(:provider, :uid, :name, :oauth_token, :oauth_expires_at)
  	  end

end
