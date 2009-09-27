#!/usr/bin/env ruby -wKU
require "subripper_options"
require "time"

class Time
  def msec
    usec/1000
  end
end

class Subripper
  def initialize
    @options = SubripperOptions.new
  end
  
  def run
    File.open(@options.output_file,"w") do |output_file|    
      File.open(@options.input_file) do |input_file|
        while not input_file.eof?
          line = input_file.gets
          matcher = /(\d+:\d+:\d+,\d+)\s*-->\s*(\d+:\d+:\d+,\d+)/.match(line)
          if matcher.nil?
            output_file.puts line
          else
            out_time = []
            [matcher[1],matcher[2]].each do |tm|
              parsed_time = Time.parse tm
              if @options.operation == "add"
                parsed_time = parsed_time + @options.time.gsub(",",".").to_f
              else
                parsed_time = parsed_time - @options.time.gsub(",",".").to_f
              end
              out_time << parsed_time.strftime("%H:%M:%S,#{parsed_time.msec}")
            end
            output_file.puts "#{out_time.first} --> #{out_time.last}" 
          end
        end
      end      
    end
  end
end

subtitles = Subripper.new
subtitles.run