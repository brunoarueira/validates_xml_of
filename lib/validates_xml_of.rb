require 'nokogiri'

module ValidatesXmlOf
  autoload :VERSION, "validates_xml_of_of/version"

  class << self
    attr_accessor :schema_paths

    def load_i18n_locales
      require 'i18n'
      I18n.load_path += Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'locales', '*.yml')))
    end

    DEFAULT_MESSAGE = 'does not appear to be a valid xml'
    DEFAULT_SCHEMA_MESSAGE = 'does not appear to be a valid xml based on schema informed'
    ERROR_MESSAGE_I18N_KEY = :invalid_xml
    ERROR_SCHEMA_MESSAGE_I18N_KEY = :invalid_xml_based_on_schema

    def default_message
      i18n_defined? ? I18n.t(ERROR_MESSAGE_I18N_KEY, scope: [:errors, :messages], default: DEFAULT_MESSAGE) : DEFAULT_MESSAGE
    end

    def default_schema_message
      i18n_defined? ? I18n.t(ERROR_SCHEMA_MESSAGE_I18N_KEY, scope: [:errors, :messages], default: DEFAULT_SCHEMA_MESSAGE): DEFAULT_SCHEMA_MESSAGE
    end

    def lookup_schema_file(schema_name)
      paths = schema_paths
      schema_file = nil

      return schema_file if paths.nil? || paths.empty?

      if paths.is_a?(String)
        schema_file = schema_file(paths, schema_name)
      else
        paths.reject(&:nil?).each do |path|
          schema_file = schema_file(path, schema_name)

          break if schema_file
        end
      end

      schema_file
    end

    protected

    def i18n_defined?
      defined?(I18n)
    end

    def schema_file(path, schema_name)
      schema_file_name = File.join(path, "#{schema_name}.xsd")

      if File.exist?(schema_file_name) && !File.directory?(schema_file_name)
        return File.open(schema_file_name)
      end
    end
  end

  self.schema_paths = []

  def self.setup
    yield self
  end
end

require 'validates_xml_of/validator'
require 'validates_xml_of/active_model' if defined?(::ActiveModel)
require 'validates_xml_of/railtie' if defined?(::Rails::Railtie)
require 'validates_xml_of/matchers/validate_xml_of' if defined?(::RSpec)
