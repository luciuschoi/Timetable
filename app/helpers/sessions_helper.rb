module SessionsHelper

  

 def current_user
 end
 def logged_in_user?
		!session[:user_id].nil?
	end

end
