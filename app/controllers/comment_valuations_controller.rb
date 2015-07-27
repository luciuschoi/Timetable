class CommentValuationsController < ApplicationController
	def create
		@comment = Comment.find(params[:comment_id])

		@comment.likedcount += 1
		@comment.save!

		# 현재유저가 이 댓글에 대해 평가한적 있니?
		# 현재유저.
		if current_user.comment_valuations.find_by(comment_id: @comment.id)
			
		else
			@comment_valuation = current_user.comment_valuations.build(lecture_id: params[:lecture_id],	comment_id: params[:comment_id])
			@comment_valuation.like = 1
			
			@comment_valuation.save!
		end
		redirect_to lecture_path(params[:lecture_id])
		# @좋아요 생성
		# @좋아요.수치+1
		# 좋아요.save
		# 리다이렉팅 @lecture
	end
end
