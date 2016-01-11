# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


1.times do |n|
	subject = "알고리즘"
	professor = "나중채"
	major = "컴퓨터공학과"
	Lecture.create!(subject: subject,
					professor: professor,
					major: major)
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')