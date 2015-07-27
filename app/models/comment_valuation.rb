class CommentValuation < ActiveRecord::Base
	belongs_to :user
	belongs_to :lecture
	belongs_to :comment
end
