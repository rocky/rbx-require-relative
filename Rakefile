#!/usr/bin/env rake
# -*- Ruby -*-
# Are we rubinius? We'll test by checking the specific function we need.
raise RuntimeError, 'This package is for rubinius only!' unless
  Object.constants.include?('Rubinius') && 
  Rubinius.constants.include?('VM') && 
  Rubinius::VM.respond_to?(:backtrace)

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
test_task = task :test => :lib do 
  Rake::TestTask.new(:test) do |t|
    t.libs << './lib'
    t.pattern = 'test/test-*.rb'
    t.verbose = true
  end
end

desc "same as test"
task :check => :test

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

