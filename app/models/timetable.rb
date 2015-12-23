class Timetable < ActiveRecord::Base
	belongs_to :user
	has_many :enrollments, dependent: :destroy
end


# dup을 통해 복제 후,
# save!까지 하여 timetable_id 생성
def reproduce_timetable(original_t, t_name)
	reproduced_t = original_t.dup
	reproduced_t.update_attribute(:name, t_name)
	reproduced_t.save!
	reproduced_t
end

def reproduce_enrollment(original_t, reproduced_t)
	original_t.enrollments.each do |e|
		dup_e = e.dup
		dup_e.update_attribute(:timetable_id, reproduced_t.id)
		dup_e.save!
  	end
end