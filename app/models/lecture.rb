class Lecture < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

  
  validates :subject, presence: true, length: {maximum: 40}, uniqueness: {scope: [:professor] }
  validates :professor, length: {maximum: 40}
  validates :major, presence:true
  serialize :lecturetime
  has_many :comments 
  has_many :valuations, dependent: :destroy
  has_many :comment_valuations, dependent: :destroy
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
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     lecture = find_by_id(row["id"]) || new
  #     lecture.attributes = row.to_hash.slice("subject", "professor", "major","lecturetime", "place")

  #     lecture.save
  #   end
  # end

  # 2 DB에 있는 강의에 몇가지 COLUMN 업데이트 
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      lecture = Lecture.find_by(subject: row["subject"], professor: row["professor"])
      #lecture = find_by_id(row["id"]) || new
      lecture.update_attribute("isu", row["isu"] )

      lecture.save
    end
  end






  # 길우꺼
  # => 
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #       row.to_hash.slice("subject", "professor", "major","lecturetime")
  #       @lecture= Lecture.where(subject: row["subject"], professor: row["professor"]).first
        
         
  #    #첫번째 시도 시 하기 
  #     # @lecture.lecturetime = {:first => row["lecturetime"]}
  #   # 두번째 시도 시 하기  


  #     if(@lecture.lecturetime[:second].nil?&& @lecture.lecturetime[:first]!= row["lecturetime"])
  #        counts=@lecture.lecturetime.count 
  #       counts.times do |i|
  #       end

  #         first=@lecture.lecturetime[:first]
  #          @lecture.lecturetime = {:first => first, :second => row["lecturetime"]}
      
  #     elsif(@lecture.lecturetime[:third].nil? && @lecture.lecturetime[:first]!= row["lecturetime"]&&@lecture.lecturetime[:second]!= row["lecturetime"])
      
  #         first=@lecture.lecturetime[:first]
  #         second=@lecture.lecturetime[:second]
  #         @lecture.lecturetime = {:first => first, :second => second, :third => row["lecturetime"]}
       



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


  def self.search_timetable(search)
    unless search.nil?
      
      if (search=="인기강의")

      timetables=Timetable.group(:subject,:professor).select("count(*) as count, subject").order("count DESC")
      where(['subject Like ?', "#{timetables.subject}%"])

      else
      where(['professor LIKE ? OR subject Like ?', 
        "#{search}%", "#{search}%"])
      end
    end

  end  

  def self.search_home(search)  
      unless search.nil?
         where(['professor LIKE ? OR subject Like ?', 
        "#{search}%", "#{search}%"]).select('DISTINCT (subject), professor, acc_total, id')
      end
  end  



















end