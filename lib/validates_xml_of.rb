# frozen_string_literal: true

require 'nokogiri'

module ValidatesXmlOf
  autoload :VERSION, 'validates_xml_of_of/version'

  class << self
    attr_accessor :schema_paths

    def load_i18n_locales
      require 'i18n'
      I18n.load_path += Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'locales',
                                                            '*.yml')))
    end

    DEFAULT_MESSAGE = 'does not appear to be a valid xml'
    DEFAULT_SCHEMA_MESSAGE = 'does not appear to be a valid xml based on schema informed'
    ERROR_MESSAGE_I18N_KEY = :invalid_xml
    ERROR_SCHEMA_MESSAGE_I18N_KEY = :invalid_xml_based_on_schema

    def default_message
      if i18n_defined?
        I18n.t(ERROR_MESSAGE_I18N_KEY, scope: %i[errors messages],
                                       default: DEFAULT_MESSAGE)
      else
        DEFAULT_MESSAGE
      end
    end

    def default_schema_message
      if i18n_defined?
        I18n.t(ERROR_SCHEMA_MESSAGE_I18N_KEY, scope: %i[errors messages],
                                              default: DEFAULT_SCHEMA_MESSAGE)
      else
        DEFAULT_SCHEMA_MESSAGE
      end
    end

    def lookup_schema_file(schema_name)
      paths = schema_paths
      schema_file = nil

      return schema_file if paths.nil? || paths.empty?

      schema_file(paths, schema_name)
    end

    protected

    def i18n_defined?
      defined?(I18n)
    end

    def schema_file(paths, schema_name)
      paths = handle_paths(paths)

      return if paths.nil? || schema_name.nil?

      schema_file_names = paths.map { |path| File.join(path, "#{schema_name}.xsd") }

      schema_file_name = schema_file_names.find { |file_name| File.exist?(file_name) }

      File.open(schema_file_name) if schema_file_name
    end

    def handle_paths(paths)
      return if paths.nil?

      !paths.nil? && paths.respond_to?(:compact) ? paths.compact : [paths]
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
