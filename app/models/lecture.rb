class Lecture < ActiveRecord::Base

  include ActionView::Helpers::DateHelper
  validates :subject, presence: true, length: {maximum: 40}, uniqueness: {scope: [:professor] }
  validates :professor, length: {maximum: 40}
  validates :major, presence:true
  #has_many :comments, -> { order("comments.created_at DESC") }, dependent: :destroy
  has_many :comments 
  scope :order_by_comments, -> { joins(:comments).order("comments.created_at DESC") }
  scope :group_by_id, ->  { group(:lecture_id)}
  has_many :valuations, dependent: :destroy
  has_many :comment_valuations, dependent: :destroy

  require 'rubygems'
  require 'roo'

  def Lecture.accessible_attributes
    ["subject", "professor", "major","lecturetime"]
  end 

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      lecture = find_by_id(row["id"]) || new
      lecture.attributes = row.to_hash.slice("subject", "professor", "major","lecturetime")

      lecture.save
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def lec_uptachi
    self.uptachi += 1
  end

  def lec_hatachi
    self.hatachi += 1
  end

  def lec_valuation(counts,g,w,a,l,h,t)

    
    if self.acc_grade.nil?

        grade =  g.to_i
        workload = w.to_i
        achievement = a.to_i
        level = l.to_i
        homework = h.to_i
        total = t.to_i
        counts+=1;
        self.acc_grade = grade/counts/20;
        self.acc_workload = workload/counts/20;
        self.acc_achievement = achievement/counts/20;
        self.acc_level = level/counts/20;
        self.acc_homework = homework/counts/20; 
        self.acc_total = total/counts/20;

    else
        grade = self.acc_grade * counts + g.to_i/20
        workload =self.acc_workload * counts + w.to_i/20
        achievement =self.acc_achievement * counts + a.to_i/20
        level = self.acc_level * counts + l.to_i/20
        homework = self.acc_homework * counts + h.to_i/20
        total = self.acc_total*counts + t.to_i/20
        counts+=1;
        self.acc_grade = grade/counts
        self.acc_workload = workload/counts
        self.acc_achievement = achievement/counts
        self.acc_level = level/counts
        self.acc_homework = homework/counts
        self.acc_total = total/counts

    end   
  end



def self.search(search_from, search)  
     if search  
      if(search_from=='강의')
      where('subject LIKE ?', "%#{search}%")  
    elsif(search_from=='교수')
      where('professor LIKE ?', "%#{search}%")
    elsif(search_from=='개설학과')
      where('major LIKE ?', "%#{search}%")
    elsif(search_from=='강의시간')
      where('lecturetime LIKE ?', "%#{search}%")
    
      end
     else  
     scoped
     end  
   end  




















end