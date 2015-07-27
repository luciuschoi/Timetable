module SessionsHelper

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

 def logged_in_user?
		!session[:user_id].nil?
	end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user 
  end 
	
end
