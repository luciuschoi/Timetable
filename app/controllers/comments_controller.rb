class CommentsController < ApplicationController
	def create
		@comment = current_user.comments.build(lecture_id: params[:lecture_id],
									content: params[:comment][:content])

		@comment.save

		redirect_to lecture_path(params[:lecture_id])
	end
end
