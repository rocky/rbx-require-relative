#!/usr/bin/env rake
# -*- Ruby -*-
# Are we rubinius? We'll test by checking the specific function we need.
raise RuntimeError, 'This package is for rubinius only!' unless
  Object.constants.include?('Rubinius') && 
  Rubinius.constants.include?('VM') && 
  Rubinius::VM.respond_to?(:backtrace)

begin
  require_relative 'lib/version'
  puts 'Looks like you already have require_relative!'
  exit 5
rescue NameError
end

require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'

ROOT_DIR = File.dirname(__FILE__)
require File.join(ROOT_DIR, '/lib/version')

def gemspec
  @gemspec ||= eval(File.read('.gemspec'), binding, '.gemspec')
end

desc "Build the gem"
task :package=>:gem
task :gem=>:gemspec do
  sh "gem build .gemspec"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
end

task :default => [:test]

desc 'Install locally'
task :install => :package do
  Dir.chdir(ROOT_DIR) do
    sh %{gem install --local pkg/#{gemspec.name}-#{gemspec.version}}
  end
end    

desc 'Test everything.'
Rake::TestTask.new(:test) do |t|
  t.libs << './lib'
  t.pattern = 'test/test-*.rb'
  t.verbose = true
end
task :test => [:lib]

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


desc "Run each library Ruby file in standalone mode."
rake_dir = File.dirname(__FILE__)
task :check do
  run_standalone_ruby_file(File.join(%W(#{rake_dir} test)))
end
task :default => [:test]

# Remove the above when I figure out what's up with the commented-out code.

desc 'Create a GNU-style ChangeLog via git2cl'
task :ChangeLog do
  system('git log --pretty --numstat --summary | git2cl > ChangeLog')
end

desc "Remove built files"
task :clean => [:clobber_package, :clobber_rdoc]

desc "Generate the gemspec"
task :generate do
  puts gemspec.to_ruby
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

task :clobber_package do
  FileUtils.rm_rf File.join(ROOT_DIR, 'pkg')
end

task :clobber_rdoc do
  FileUtils.rm_rf File.join(ROOT_DIR, 'doc')
end
