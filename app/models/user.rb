class User < ActiveRecord::Base
	 has_many :comments, dependent: :destroy
	 has_many :valuations, dependent: :destroy
   has_many :comment_valuations, dependent: :destroy
   validates :nickname, :length => { :minimum => 1, :maximum => 10 }, :uniqueness => true, :allow_nil => true 

	def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider 
      user.uid      = auth.uid
      user.name     = auth.info.name
      user.token    = auth.token
      user.save
    end
  end

  def evaluated_up(lec, what_valuated)
    valuations.create(lecture_id: lec.id, up: what_valuated)
  end
  
  def evaluated_down(lec, what_valuated)
    valuations.create(lecture_id: lec.id, down: what_valuated)
  end

end