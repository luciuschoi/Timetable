class Comment < ActiveRecord::Base

	validates :content, :length => { :minimum => 10, :maximum => 500 }

	belongs_to :user
	belongs_to :lecture	
end
