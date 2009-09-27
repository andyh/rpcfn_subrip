#!/usr/bin/env ruby -wKU
require "subripper_options"
require "time"

#  Reopen Time class and define method for getting milliseconds
class Time
  def msec
    usec/1000
  end
end

class Subripper
  def initialize
    @options = SubripperOptions.get(ARGV)
  end
  
  def run
    srt_in  = File.readlines(@options.input_file)
    srt_out = Array.new
    
    srt_in.each do |line|
      matcher = /(\d+:\d+:\d+,\d+)\s*-->\s*(\d+:\d+:\d+,\d+)/.match(line)      
      srt_out << (matcher.nil? ? line : parse_time(matcher))
    end
    
    File.open(@options.output_file,"w") { |output_file| output_file.write srt_out }
  end
  
  def parse_time(matchdata)
    out_time = Array.new
    [matchdata[1],matchdata[2]].each do |tm|
      parsed_time = Time.parse tm
      case @options.operation
        when :add
          parsed_time = parsed_time + @options.time.gsub(",",".").to_f
        when :sub
          parsed_time = parsed_time - @options.time.gsub(",",".").to_f
        end
      out_time << parsed_time.strftime("%H:%M:%S,#{parsed_time.msec.to_s.rjust(3,'0')}")
    end
    "#{out_time.first} --> #{out_time.last}\n"
  end
end

subtitles = Subripper.new
subtitles.run