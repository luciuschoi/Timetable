class Comment < ActiveRecord::Base
	include ActionView::Helpers::DateHelper
	validates :content, :length => { :minimum => 1, :maximum => 500 }
	belongs_to :user
	belongs_to :lecture	
	has_many :comment_valuations, dependent: :destroy

	def timestamp_division
		difference = Time.zone.now - created_at
		
		if difference < 60
			"방금전"

		# 0~59분전
		# 현재시간 - 댓글 작성시간 = 1~59분 
		elsif difference > 60 && difference < 3600
			(difference/60).to_i.to_s + "분전"
		
		elsif difference > 3600 && difference < 86400
			(difference/3600).to_i.to_s + "시간전"
		# 현재시각 3시 10분 - 작성 시간 2시 10분 1시간 

		# 1시간~23시간전
		# 현재시간 - 댓글 작성시간 = 1시간~23시간전
		# X시간전			

		else
			created_at.strftime("%m/%d %H:%M")

		end
		# X월X일  
	end

end

