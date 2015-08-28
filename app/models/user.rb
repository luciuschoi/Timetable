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

<<<<<<< HEAD
=======

  def evaluated_valuation(lec,g,w)
    valuations.create(lecture_id: lec.id, grade: g, workload: w)
    #valuations.create(lecture_id: lec.id, grade: g, workload: w,
    # level: l, achievement: a, total: t)
  end
 
  

>>>>>>> parent of 675b053... 0825 강제강의평가페이지+ 강제세부강의평가페이지
end