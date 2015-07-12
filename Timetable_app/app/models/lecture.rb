class Lecture < ActiveRecord::Base
	validates :subject, presence: true, length: {maximum: 40}
	validates :professor, length: {maximum: 40}
	validates :major, presence:true
require 'rubygems'
require 'roo'



def Lecture.accessible_attributes
  ["subject", "professor", "major"]
end 

def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    lecture = find_by_id(row["id"]) || new
    lecture.attributes = row.to_hash.slice("subject", "professor", "major")

    lecture.save!
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
end