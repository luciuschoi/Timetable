class Lecture < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

  validates :subject, presence: true, length: {maximum: 40}, uniqueness: {scope: [:professor] }
  validates :professor, length: {maximum: 40}
  validates :major, presence:true
  serialize :lecturetime
  
  has_many :plural_attrs, dependent: :destroy
  has_many :comments 
  has_many :valuations, dependent: :destroy
  has_many :comment_valuations, dependent: :destroy
  has_many :enrollment
  belongs_to :timetable

  scope :order_by_comments, -> { joins(:comments).order("comments.created_at DESC") }
  scope :group_by_id, ->  { group(:lecture_id)}

  require 'rubygems'
  require 'roo'

  # IMPORT 2종류                           #
  #                                       #
  # 1  새로운 강의 추가                       #
  # 2  DB에 있는 강의에 몇가지 COLUMN 업데이트   #

  # 1 기존에 없던 강의 추가 

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      lecture = find_by(subject: row["subject"], professor: row["professor"])

      if lecture
        
      else
        lecture = Lecture.new
      end
      lec_plural_attrs = lecture.plural_attrs.build(lectureTime: row["lecturetime"], place: row["place"])
      lec_plural_attrs.save
      # 현재 엑셀의 column 개수와 업데이트 할 attr 개수 일치 확인.
      # lecture.attributes = row.to_hash.slice("subject", "professor", "major", "place", "isu","semester", "open_department", "credit")
      lecture.save
      #lecture.lecturetime = [row["lecturetime"]]
      
    end
  end


  # 2 DB에 있는 강의에 몇가지 COLUMN 업데이트 
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     @lecture = Lecture.find_by(subject: row["subject"], professor: row["professor"])
  #     # lecture = find_by_id(row["id"]) || new
  #     # lecture.update_attribute("isu", row["isu"] )
  #     # lecture.update_attribute("place", row["place"] )
  #     if @lecture
  #       @lecture.update_attribute("semester", row["semester"])
  #       @lecture.update_attribute("lecturetime", row["lecturetime"])
  #       @lecture.update_attribute("place", row["place"])
  #       @lecture.update_attribute("isu", row["isu"])
  #       @lecture.update_attribute("credit", row["credit"])
  #       @lecture.save
  #     end
  #   end
  # end
  


  # 3 DB에 있는 강의 중 lecturetime 업데이트.. 좀 복잡한거 설명 들어야함
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     lecture = Lecture.find_by(subject: row["subject"], professor: row["professor"])
  #     #lecture = find_by_id(row["id"]) || new
  #     # lecture.update_attribute("isu", row["isu"] )
  #     # lecture.update_attribute("place", row["place"] )
      
  #     # if lecture.lecturetime == nil
  #     if lecture 
  #       @bool_value = true
  #         # 강의시간이 
  #         if lecture.lecturetime.length != 0  
  #           lecture.lecturetime.each do |time|
  #             if time == row["lecturetime"]
  #               @bool_value = false
  #             end
  #           end
          
  #         end

  #         if @bool_value
  #           lecture.lecturetime << row["lecturetime"]  
  #         end
  #       lecture.save
  #     end
  #     # elsif lecture.lecturetime.length >= 1
  #     #   lecture.lecturetime << row["lecturetime"]
  #     # end
  #     # lecture.lecturetime = [row["lecturetime"]]
  #   end
  # end




  # 길우꺼
  # => 
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     row.to_hash.slice("subject", "professor", "major","lecturetime")
  #     @lecture= Lecture.where(subject: row["subject"], professor: row["professor"]).first
        
  #     byebug
  #    #첫번째 시도 시 하기 
  #     @lecture.lecturetime = {:first => row["lecturetime"]}
  #   # 두번째 시도 시 하기  


  #     # if(@lecture.lecturetime[:second].nil? && @lecture.lecturetime[:first] != row["lecturetime"])
  #     #   counts=@lecture.lecturetime.count 

  #     #   counts.times do |i|
  #     #   end

  #     #   first=@lecture.lecturetime[:first]
  #     #   @lecture.lecturetime = {:first => first, :second => row["lecturetime"]}

  #     # elsif(@lecture.lecturetime[:third].nil? && @lecture.lecturetime[:first]!= row["lecturetime"]&&@lecture.lecturetime[:second]!= row["lecturetime"])

  #     #   first=@lecture.lecturetime[:first]
  #     #   second=@lecture.lecturetime[:second]
  #     #   @lecture.lecturetime = {:first => first, :second => second, :third => row["lecturetime"]}
  #     # end
  #   end
  # end

       



  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
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
        self.acc_total = total/counts;

    else
        grade = self.acc_grade * counts + g.to_i/20
        workload =self.acc_workload * counts + w.to_i/20
        achievement =self.acc_achievement * counts + a.to_i/20
        level = self.acc_level * counts + l.to_i/20
        homework = self.acc_homework * counts + h.to_i/20
        total = self.acc_total*counts + t.to_i
        counts+=1;
        self.acc_grade = grade/counts
        self.acc_workload = workload/counts
        self.acc_achievement = achievement/counts
        self.acc_level = level/counts
        self.acc_homework = homework/counts
        self.acc_total = total/counts
    end   
  end

  def self.search_timetable(search, semester)
    unless search.nil?
      where(['(professor LIKE ? OR subject LIKE ? OR open_department LIKE ?)AND semester LIKE ?',
             "#{search}%","%#{search}%","#{search}%", "#{semester}"])
    end
  end  

  def self.search_home(search)  
      unless search.nil?
         where(['professor LIKE ? OR subject Like ?', 
        "#{search}%", "#{search}%"]).select('DISTINCT (subject), professor, acc_total, id')
      end
  end  

  def self.detailSearch(major, isu)
      where(['major LIKE ? OR isu Like ?', "#{major}%","#{isu}%"]).order('acc_total DESC')
  end


  def name
    subject + " "
  end

  













end