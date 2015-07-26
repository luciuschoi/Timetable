class Comment < ActiveRecord::Base

	validates :content, :length => { :minimum => 1, :maximum => 500 }

	belongs_to :user
	belongs_to :lecture	
end

