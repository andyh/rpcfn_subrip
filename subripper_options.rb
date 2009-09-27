require "optparse"

class SubripperOptions
  attr_accessor :input_file, :output_file
  
  def initialize
    @options = {}
    parser
  end

  def operation
    @options[:operation]
  end
  
  def time
    @options[:time]
  end
  
private
  
  def parser
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: subripper --operation <operation> --time <timecode> input_file output_file"

      # Define the options, and what they do
      @options[:operation] = nil
      opts.on( '-o', '--operation OPERATION', 'Define Operation Type' ) do |op|
        @options[:operation] = op if ['add','sub'].include?(op)
      end
      @options[:time] = nil
      opts.on( '-t', '--time TIME', 'Define Time' ) do |time|
        @options[:time] = time # if valid time code format
      end

      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end

    optparse.parse!
    
    self.input_file = ARGV.first
    self.output_file = ARGV.last
  
  end
end
