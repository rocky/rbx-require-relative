# Ruby 1.9's require_relative.
module Kernel
  # WARNING: I think there's a subtle bug lurking here because
  # Rubinius::VM.backtrace does not store absolute paths. I think it
  # should.  But for my kind of usage where require_relative is
  # generally at the top of a file, one doesn't notice the bug.
  def require_relative(suffix)
    dir = File.expand_path(File.dirname(Rubinius::VM.backtrace(1)[0].file))
    require File.join(dir, suffix)
  end
end

# demo
if __FILE__ == $0
  require 'tmpdir'
  Dir.chdir(Dir.tmpdir) do 
    rel_file = File.basename(__FILE__)
    cur_dir  = File.basename(File.dirname(__FILE__))
    ['./', "../#{cur_dir}/"].each do |prefix|
      test = "#{prefix}#{rel_file}"
      puts "#{test}: #{require_relative test}"
      puts "#{test}: #{require_relative test}"  # Shows
    end
  end
end
