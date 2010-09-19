#!/usr/bin/env rake
# -*- Ruby -*-
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

# Are we rubinius? We'll test by checking the specific function we need.
raise RuntimeError, 'This package is for rubinius only!' unless
  Object.constants.include?('Rubinius') && 
  Rubinius.constants.include?('VM') && 
  Rubinius::VM.respond_to?(:backtrace)

rake_dir = File.dirname(__FILE__)

desc 'Create a GNU-style ChangeLog via git2cl'
task :ChangeLog do
  system('git log --pretty --numstat --summary | git2cl > ChangeLog')
end

desc "Test everything."
test_task = task do 
  Rake::TestTask.new(:test) do |t|
    t.pattern = 'test/test-*.rb'
    t.verbose = true
  end
end

FILES = FileList[%w(
  README.textile 
  LICENSE
  NEWS
  ChangeLog
  Rakefile
  test/test-rr.rb
  require_relative.rb
)]

spec = Gem::Specification.new do |spec|
  spec.name = 'rbx-require-relative'
  spec.homepage = 'http://wiki.github.com/rocky/rbx-require-relative'
  spec.summary = "Ruby 1.9's require_relative for rubinius < 1.1"

  spec.version = '0.0.1'
  spec.author = "R. Bernstein"
  spec.email = "rockyb@rubyforge.org"
  spec.platform = Gem::Platform::RUBY
  spec.files = FILES.to_a

  spec.date = Time.now
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w(README.textile)
end

# Rake task to build the default package
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

def install(spec, *opts)
  args = ['gem', 'install', "pkg/#{spec.name}-#{spec.version}.gem"] + opts
  system(*args)
end

desc 'Install locally'
task :install => :package do
  Dir.chdir(File::dirname(__FILE__)) do
    # ri and rdoc take lots of time
    install(spec, '--no-ri', '--no-rdoc')
  end
end    

task :install_full => :package do
  Dir.chdir(File::dirname(__FILE__)) do
    install(spec)
  end
end    


# rake test isn't working so do it also this way via "rake check"
# The below is stripped down from other code which is why it looks 
# overblown for what it is.
require 'rbconfig'
RUBY_PATH = File.join(RbConfig::CONFIG['bindir'],  
                      RbConfig::CONFIG['RUBY_INSTALL_NAME'])
def run_standalone_ruby_file(directory)
  # puts ('*' * 10) + ' ' + directory + ' ' + ('*' * 10)
  Dir.chdir(directory) do
    Dir.glob('test-rr.rb').each do |ruby_file|
      # puts( ('-' * 20) + ' ' + ruby_file + ' ' + ('-' * 20))
      system(RUBY_PATH, ruby_file)
    end
  end
end

task :default => [:check]

desc "Run each library Ruby file in standalone mode."
rake_dir = File.dirname(__FILE__)
task :check do
  run_standalone_ruby_file(File.join(%W(#{rake_dir} test)))
end
