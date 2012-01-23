# -*- Ruby -*-
# -*- encoding: utf-8 -*-
require 'rake'
require 'rubygems' unless 
  Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/version" unless 
  Object.const_defined?(:RequireRelative)

FILES = FileList[%w(
  LICENSE
  ChangeLog
  NEWS
  README.textile 
  Rakefile
  lib/*.rb
  test/*.rb
)]

Gem::Specification.new do |spec|
  spec.authors      = ['R. Bernstein']
  spec.date         = Time.now
  spec.description  = <<-DESCRIBE
Ruby 1.9's require_relative for Rubinius and MRI 1.8. 

We also add abs_path which is like __FILE__ but __FILE__ can be fooled
by a sneaky "chdir" while abs_path can't. 

If you are running on Ruby 1.9 or greater, require_relative is the
pre-defined version.  The benefit we provide in this situation by this
package is the ability to write the same require_relative sequence in
Rubinius 1.8 and Ruby 1.9.
  DESCRIBE
  spec.email        = 'rockyb@rubyforge.net'
  spec.files        = FILES.to_a  
  spec.homepage     = 'http://github.com/rocky/rbx-require-relative'
  spec.name         = 'rbx-require-relative'
  spec.license      = 'MIT'

  spec.require_path = 'lib'
  spec.required_ruby_version = "~> #{RUBY_VERSION}"

  spec.summary      = spec.description
  spec.version      = RequireRelative::VERSION
  spec.has_rdoc     = true

  spec.rdoc_options += ['--title', 
               "require_relative #{RequireRelative::VERSION} Documentation"]

  if (defined?(RUBY_DESCRIPTION) && 
      RUBY_DESCRIPTION.start_with?('ruby 1.9.2frame'))
    spec.add_dependency('rb-threadframe')
    spec.platform = Gem::Platform::new ['universal', 'ruby', '1.9.2']
  elsif (defined?(RUBY_DESCRIPTION) && 
      RUBY_DESCRIPTION.start_with?('ruby 1.9.2'))
    spec.platform = Gem::Platform::new ['universal', 'ruby', '1.9.2']
  elsif (defined?(RUBY_DESCRIPTION) && 
      RUBY_DESCRIPTION.start_with?('ruby 1.9.3'))
    spec.platform = Gem::Platform::new ['universal', 'ruby', '1.9.3']
  elsif Object.constants.include?('Rubinius') && 
      Rubinius.constants.include?('VM')
    spec.platform = Gem::Platform::new ['universal', 'rubinius', '1.2']
  elsif (RUBY_VERSION.start_with?('1.8.7') && 
         (RUBY_COPYRIGHT.end_with?('Yukihiro Matsumoto')) ||
       RUBY_ENGINE == 'jruby')
    spec.platform = Gem::Platform::new ['universal', 'jruby', '1.2']
  end
end
