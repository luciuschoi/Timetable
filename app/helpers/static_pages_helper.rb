module StaticPagesHelper

	
  def user_login?
      if(session[:user_id].nil?&&session[:user_name].nil?)
          false
      else 
          true
     end
  end
end
