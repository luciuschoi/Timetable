class User < ActiveRecord::Base
	 has_many :comments
	 has_many :valuations
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

  def evaluated(lec, what_valuated)
    valuations.create(lecture_id: lec.id, valuated: what_valuated)
  end

  def revaluated(lec, what_valuated)
    v = valuations.find_by(lecture_id: lec.id)
    v.update_attribute(:valuated, what_valuated)
  end

end