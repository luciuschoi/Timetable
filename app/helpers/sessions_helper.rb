module SessionsHelper

  

 def logged_in_user?
		!session[:user_id].nil?
	end

end
