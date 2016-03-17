# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'validates_xml/version'

Gem::Specification.new do |spec|
  spec.name          = "validates_xml"
  spec.version       = ValidatesXml::VERSION
  spec.authors       = ["Bruno Arueira"]
  spec.email         = ["contato@brunoarueira.com"]

  spec.summary       = %q{Validates if an attribute has a valid xml content or a xsd valid content.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/brunoarueira/validates_xml"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_dependency "i18n"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "activemodel", ">= 3.0"
end
