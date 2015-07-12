module SessionsHelper

	def current_user
		@current_user = User.find_by( id: session[:current_user_id] )

	end


	def user_signed_in?
		!current_user.nil?
	end

	def sign_in(user)
		session[:current_user_id] = user.id
	end

	def sign_out
		@current_user = nil
		session.delete(:session)
		session.delete(:current_user_id)

	end

	def user_session
	end

end
