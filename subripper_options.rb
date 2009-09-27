require "optparse"
require "ostruct"

class SubripperOptions
  def self.parse(args)
    begin
      options             = OpenStruct.new
      options.input_file  = nil
      options.output_file = nil
      options.operation   = nil
      options.time        = nil
      
      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: subripper --operation <operation> --time <timecode> input_file output_file"
        
        # All arguments are mandatory
        opts.on( '-o', '--operation OPERATION', [:add, :sub], 'Set operation type, either "add" or "sub"(tract)' ) do |op|
          options.operation = op
        end

        opts.on( '-t', '--time TIME', 'Set Time, e.g. 02,300' ) do |time|
          options.time = time
        end

        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
        end
      end

      optparse.parse!
    
      options.input_file = ARGV.first
      options.output_file = ARGV.last
      
      options
    rescue OptionParser::InvalidArgument => e
      puts e
      exit
    end
  
  end
end
