#!/usr/bin/env rake
# -*- Ruby -*-
# begin
#   require_relative 'lib/version'
#   puts 'Looks like you already have require_relative!'
#   exit 5
# rescue NameError
# end

require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'
require 'fileutils'

ROOT_DIR = File.dirname(__FILE__)
require File.join(ROOT_DIR, '/lib/version')

def gemspec
  @gemspec ||= eval(File.read('.gemspec'), binding, '.gemspec')
end

def gem_file
  if gemspec.platform.to_s == 'ruby' 
    "#{gemspec.name}-#{gemspec.version}.gem"
  else
    "#{gemspec.name}-#{gemspec.version}-#{gemspec.platform.to_s}.gem"
  end
end


desc "Build the gem"
task :package=>:gem
task :gem=>:gemspec do
  sh "gem build .gemspec"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv gem_file, 'pkg'
end

task :default => [:test]

desc 'Install locally'
task :install => :package do
  Dir.chdir(ROOT_DIR) do
    sh %{gem install --local pkg/#{gem_file}}
  end
end    

desc 'Test everything.'
Rake::TestTask.new(:test) do |t|
  t.libs << './lib'
  t.pattern = 'test/test-*.rb'
  t.options = '--verbose' if $VERBOSE
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

desc "Generate the gemspec"
task :generate do
  puts gemspec.to_ruby
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

desc 'Remove residue from running patch'
task :rm_patch_residue do
  FileUtils.rm_rf FileList['**/*.{rej,orig}'].to_a, :verbose => true
end

desc 'Remove ~ backup files'
task :rm_tilde_backups do
  FileUtils.rm_rf Dir.glob('**/*~'), :verbose => true
  FileUtils.rm_rf Dir.glob('**/*.rbc'), :verbose => true
end

desc "Remove built files"
task :clean => [:clobber_package, :clobber_rdoc, :rm_patch_residue, :rm_tilde_backups]

task :clobber_package do
  FileUtils.rm_rf File.join(ROOT_DIR, 'pkg')
end

task :clobber_rdoc do
  FileUtils.rm_rf File.join(ROOT_DIR, 'doc')
end
