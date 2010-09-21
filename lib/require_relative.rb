# Ruby 1.9's require_relative.
module RequireRelative
  def abs_file
    Rubinius::VM.backtrace(1)[0].method.scope.data_path
  end
  module_function :abs_file
end

module Kernel
  def require_relative(suffix)
    # Rubinius::Location#file stores relative file names while
    # Rubinius::Location#scope.data store the absolute file name. It
    # is possible (hopeful even) that in the future that Rubinius will
    # change the API to be more intuitive. When that occurs, I'll
    # change the below to that simpler thing.
    dir = File.dirname(Rubinius::VM.backtrace(1)[0].
                       method.scope.data_path)
    require File.join(dir, suffix)
  end
end

# demo
if __FILE__ == $0
  file = RequireRelative.abs_file
  puts file
  require 'tmpdir'
  Dir.chdir(Dir.tmpdir) do 
    rel_file = File.basename(file)
    cur_dir  = File.basename(File.dirname(file))
    ['./', "../#{cur_dir}/"].each do |prefix|
      test = "#{prefix}#{rel_file}"
      puts "#{test}: #{require_relative test}"
      puts "#{test}: #{require_relative test} -- should be false"
    end
  end
end
