class CommentsController < ApplicationController
	def create
		if logged_in_user?
			@comment = current_user.comments.build(lecture_id: params[:lecture_id],
									content: params[:comment][:content])

			@comment.save

		redirect_to lecture_path(params[:lecture_id])
		else
			redirect_to "/auth/facebook", id: "sign_in" 
	end
end
