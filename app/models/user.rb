class User < ActiveRecord::Base
	 has_many :comments, dependent: :destroy
	 has_many :valuations, dependent: :destroy
   has_many :comment_valuations, dependent: :destroy
   validates :nickname, presence: true, :length => { :minimum => 1, :maximum => 10 }, :uniqueness => true, :allow_nil => true 

   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email, presence: true, length: {maximum: 155}, 
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
   
   validates :password, presence: true, length: { minimum: 6 }
   has_secure_password


	def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider 
      user.uid      = auth.uid
      user.name     = auth.info.name
      user.token    = auth.token
      user.save
    end
  end

  def evaluated_valuation(lec,g,w,a,l,h,t,c)
    valuations.create(lecture_id: lec.id, grade: g, workload: w, achievement: a, 
      level: l, homework: h, total: t, content: c)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
 
end