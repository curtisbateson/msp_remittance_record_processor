require 'csv'

S0_OTHER_CODES = ["S00","S02","S03"]
S01_FIELD_LENGTHS = [3,5,7,8,1,5,6,5,2,7,2,7,2,7,2,7,2,7,2,7,2,7,7,7,8,2,8,2,29]
S0_OTHER_FIELD_LENGTHS = [3,5,7,8,1,5,6,5,8,2,18,10,2,8,2,3,2,5,7,3,2,5,7,7,2,2,2,2,2,2,2,2,7,2,7,2,7,2,7,2,7,2,7,2,7,10,1,8,2,8,31]

def process_line(line)
  code = line.slice(0,3)

  if code == "S01"
    S01_FIELD_LENGTHS.map{ |length| line.slice!(0,length) }
  elsif S0_OTHER_CODES.include?(code)
    S0_OTHER_FIELD_LENGTHS.map{ |length| line.slice!(0,length) }
  else
    [line]
  end
end

File.open('msp_raw.txt') do |f|
  raw_lines = f.read.each_line
  processed_lines = []

  raw_lines.each do |line|
    processed_lines << process_line(line)
  end

  CSV.open("./msp_processed_#{Time.now.strftime("%FT%R")}.csv", "wb") do |csv|
    processed_lines.each do |line|
      csv << line
    end
  end
end
