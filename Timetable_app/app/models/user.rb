class User < ActiveRecord::Base
	before_save { self.email=email.downcase }
	has_secure_password
	validates :name, presence: true, length: { minimum: 2 , maximum: 10}
	validates :email, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false }
    validates :nickname, length: { maximum: 20 }
	def authenticate (password)
		BCrypt::Password.new(self.password_digest)== password
	end

 
end
