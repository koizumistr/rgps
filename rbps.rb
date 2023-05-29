require 'optparse'

long_desc = false
opt = OptionParser.new
opt.banner = 'Usage: rbps.rb [option] PATTERN'
opt.on('-l', 'display long description') { long_desc = true }
opt.version = [1, 0]

begin
  opt.parse!(ARGV)
rescue
  puts opt.help
  exit(-2)
end

if ARGV.empty?
  puts opt.help
  exit(-3)
end

ver = `uname -r`
if /(?<major>\d+)\.(?<minor>\d+)/ =~ ver
  exit(-1) if major.nil?
end

File.open('/usr/ports/INDEX-' + major, 'r') do |file|
  file.each_line do |line|
    if /(?<name>[^|]+)\|(?<origin>[^|]+)\|(?<prefix>[^|]+)\|(?<desc>[^|]*)\|(?<descpath>[^|]+)\|(?<maintainer>[^|]+)\|(?<categories>[^|]+)/ =~ line
      if origin.match?(/#{ARGV[0]}/i) || desc.match?(/#{ARGV[0]}/i)
        print origin.gsub('/usr/ports/', ''), "\t", desc, "\n"
        if long_desc
          begin
            File.open(descpath, 'r') do |desc_file|
              desc_file.each_line do |line|
                print "\t", line
              end
            end
          rescue
          end
          print "\n"
        end
      end
    end
  end
end
