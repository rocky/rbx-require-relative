# Ruby 1.9's require_relative.

if defined?(RubyVM)
  require 'thread_frame'
end

module RequireRelative
  def abs_file
    if defined?(RubyVM::ThreadFrame)
      RubyVM::ThreadFrame.current.prev.source_container[1]
    elsif defined?(Rubinius) && "1.8.7" == RUBY_VERSION
      scope = Rubinius::StaticScope.of_sender
      script = scope.current_script
      if script
        script.data_path
      else
        nil
      end
    end
  end
  module_function :abs_file
end
  
# On platforms other than Rubinius for 1.8.7
# don't do anything.
if defined?(Rubinius) && "1.8.7" == RUBY_VERSION
  module Kernel
    def require_relative(suffix)
      # Rubinius::Location#file stores relative file names while
      # Rubinius::Location#scope.current_script.data_path stores the
      # absolute file name. It is possible (hopeful even) that in the
      # future that Rubinius will change the API to be more
      # intuitive. When that occurs, I'll change the below to that
      # simpler thing.
      scope = Rubinius::StaticScope.of_sender
      script = scope.current_script
      if script
        require File.join(File.dirname(script.data_path), suffix)
      else
        raise LoadError "Something is wrong in trying to get relative path"
      end
    end
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
