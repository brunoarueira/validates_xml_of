# frozen_string_literal: true

module ValidatesXmlOf
  class Validator
    def initialize(xml, options = {})
      self.xml = xml
      self.options = options
    end

    def validate
      message = handle_nil_or_empty_content(xml)

      message = merged_options[:message] unless valid_xml?(xml)

      return message unless message.nil?

      handle_content_schema_based(xml)
    end

    protected

    attr_accessor :xml, :options

    def default_options
      @default_options ||= {
        message: ValidatesXmlOf.default_message,
        schema_message: ValidatesXmlOf.default_schema_message
      }
    end

    def merged_options
      @merged_options ||= options.merge(default_options) { |_, old, _| old }
    end

    def valid_xml?(document_content)
      Nokogiri::XML(document_content).errors.empty?
    end

    def valid_xml_based_on_schema?(document_content, schema)
      schema = Nokogiri::XML::Schema(schema)
      document = Nokogiri::XML(document_content)

      schema.validate(document).empty?
    end

    def handle_nil_or_empty_content(xml)
      if xml.nil? || xml.empty? || !xml.is_a?(String)
        message = if options[:schema]
                    merged_options[:schema_message]
                  else
                    merged_options[:message]
                  end
      end

      message
    end

    def handle_content_schema_based(xml)
      if options[:schema]
        schema = ValidatesXmlOf.lookup_schema_file(options[:schema])

        return merged_options[:schema_message] if schema.nil?

        message = merged_options[:schema_message] if !schema.nil? && !valid_xml_based_on_schema?(xml, schema)
      end

      message
    end
  end
end
