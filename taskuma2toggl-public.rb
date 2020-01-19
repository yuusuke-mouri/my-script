#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'csv'
require 'pp'
require 'time'

csv_data = CSV.read(ARGV[0], headers: true)

user = "Your Name"
email= "Your Email Address"
jst=":00 +0900"

lines = []

# https://support.toggl.com/en/articles/2216070-editing-and-uploading-a-csv-file
lines.push(["User","Email","Client","Project","Task","Description","Billable","Start date","Start time","End date","End time","Duration","Tags","Amount ()"])

csv_data.each do |d|
  str_s = d["startTime"] + jst
  str_e = d["endTime"] + jst
  duration = Time.parse(str_e) - Time.parse(str_s)
#  hour = (( duration / 60 / 60 )).to_i
#  min  = (( duration - hour * 3600 ) / 60).to_i
#  sec  = (( duration - hour * 3600 - min * 60 )).to_i

  timestr_s = str_s.split(/ /)
  timestr_e = str_e.split(/ /)

  lines.push([
    user,
    email,
    "",
    d["projectName"],
    "",
    d["taskName"],
    "No",
    d["startTime"].sub(/ /, ',').gsub(/\//,"-").sub(/$/,":00"),
    d["endTime"].sub(/ /, ',').gsub(/\//,"-").sub(/$/,":00"),
    Time.at(duration.to_i).utc.strftime('%X'),
    '"' + d["tag"] + '"',
    ""
  ])
end

File.open(ARGV[0].sub(/\.csv/, '') + "-toggl.csv", "w") do |f|
  lines.each { |v| f.puts(v.join(",")) }
end

