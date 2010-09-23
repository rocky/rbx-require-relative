# -*- Ruby -*-
# -*- encoding: utf-8 -*-
require 'rake'
require 'rubygems' unless 
  Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/version" unless 
  Object.const_defined?(RequireRelative)

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
  spec.description  = %q{
Ruby 1.9's require_relative for Rubinius
}
  spec.email        = 'rockyb@rubyforge.net'
  spec.files        = FILES.to_a  
  spec.homepage     = 'http://github.com/rocky/rbx-require-relative'
  spec.name         = 'rbx-require-relative'
  spec.license      = 'MIT'
  spec.platform     = Gem::Platform::RUBY
  spec.require_path = 'lib'
  spec.required_ruby_version = '~> 1.8.7'
  spec.summary      = spec.description
  spec.version      = RequireRelative::VERSION
  spec.has_rdoc     = true

  # Make the readme file the start page for the generated html
  spec.rdoc_options += %w(--main README)
  spec.rdoc_options += ['--title', 
               "require_relative #{RequireRelative::VERSION} Documentation"]

end
