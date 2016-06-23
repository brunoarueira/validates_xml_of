module ValidatesXmlOf
  class Validator
    def initialize(xml, options = {})
      self.xml = xml
      self.options = options
    end

    def validate
      message = nil

      if xml.nil? || xml.empty? || !xml.is_a?(String)
        if options[:schema]
          message = merged_options[:schema_message]
        else
          message = merged_options[:message]
        end
      end

      if !is_a_valid_xml?(xml)
        message = merged_options[:message]
      end

      return message unless message.nil?

      if options[:schema]
        schema = lookup_schema_file(options[:schema])

        return merged_options[:schema_message] if schema.nil?

        if !schema.nil? && !is_a_valid_xml_based_on_schema?(xml, schema)
          message = merged_options[:schema_message]
        end
      end

      return message
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

    def is_a_valid_xml?(document_content)
      Nokogiri::XML(document_content).errors.empty?
    end

    def is_a_valid_xml_based_on_schema?(document_content, schema)
      schema = Nokogiri::XML::Schema(schema)
      document = Nokogiri::XML(document_content)

      schema.validate(document).empty?
    end

    def lookup_schema_file(schema_name)
      paths = ValidatesXmlOf.schema_paths
      schema_file = nil

      return schema_file if paths.empty? || paths.nil?

      if paths.is_a?(String)
        schema_file = schema_file(paths, schema_name)
      else
        paths.reject(&:nil?).each do |path|
          schema_file = schema_file(path, schema_name)

          break unless schema_file
        end
      end

      schema_file
    end

    def schema_file(path, schema_name)
      schema_file_name = File.join(path, "#{schema_name}.xsd")

      if File.exist?(schema_file_name) && !File.directory?(schema_file_name)
        return File.open(schema_file_name)
      end
    end
  end
end
