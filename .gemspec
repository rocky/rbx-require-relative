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
end
