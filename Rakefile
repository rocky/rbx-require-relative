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
require 'rbconfig'
RUBY_PATH = File.join(RbConfig::CONFIG['bindir'],  
                      RbConfig::CONFIG['RUBY_INSTALL_NAME'])

desc 'Create a GNU-style ChangeLog via git2cl'
task :ChangeLog do
  system('git log --pretty --numstat --summary | git2cl > ChangeLog')
end

desc 'Test units - the smaller tests'
task :'test:unit' do |t|
  Rake::TestTask.new(:'test:unit') do |t|
    t.test_files = FileList['test/test-*.rb']
    # t.pattern = 'test/**/*test-*.rb' # instead of above
    t.verbose = true
  end
end

desc 'Test everything - unit tests for now.'
task :test do
  exceptions = %w(test:unit).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      e
    end
  end.compact
  
  exceptions.each {|e| puts e;puts e.backtrace }
  raise "Test failures" unless exceptions.empty?
end

desc "Test everything - same as test."
task :default => :test

FILES = FileList[%w(
  README.textile 
  LICENSE
  NEWS
  ChangeLog
  Rakefile
  test/*.rb
  require_relative.rb
)]

spec = Gem::Specification.new do |spec|
  spec.name = 'rbx-require_relative'
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
