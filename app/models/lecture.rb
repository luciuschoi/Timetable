class Lecture < ActiveRecord::Base

  include ActionView::Helpers::DateHelper
  attr_accessor :id
  validates :subject, presence: true, length: {maximum: 40}, uniqueness: {scope: [:professor] }
  validates :professor, length: {maximum: 40}
  validates :major, presence:true

  has_many :comments 
  has_many :valuations, dependent: :destroy
  has_many :comment_valuations, dependent: :destroy
  belongs_to :timetable
  scope :order_by_comments, -> { joins(:comments).order("comments.created_at DESC") }
  scope :group_by_id, ->  { group(:lecture_id)}

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

  def id
      return self.id
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



  def self.search(search)  
      unless search.nil?
      where(['professor LIKE ? OR subject Like ?', 
        "#{search}%", "#{search}%"])
    end

  end  



















end