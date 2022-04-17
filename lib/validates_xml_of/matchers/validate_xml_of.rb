# frozen_string_literal: true

require 'validates_xml_of'

module ValidatesXmlOf
  module Matchers
    class ValidateXmlOf
      def initialize(attribute)
        @attribute = attribute
      end

      def matches?(given_record)
        @given_record = given_record

        @expected_message ||= ValidatesXmlOf.default_message

        valid_xml? && valid_xml_based_on_schema?
      end

      def with_schema(schema)
        @schema = schema
        @expected_message ||= ValidatesXmlOf.default_schema_message

        self
      end

      def description
        description = "#{@attribute} contains a valid xml"

        description << " based on '#{@schema}'" if @schema

        description
      end

      def with_message(expected_message)
        @expected_message = expected_message

        self
      end

      def failure_message
        "Expected #{@attribute} to contains a valid xml, but it is #{attribute_output.inspect}"
      end

      def failure_message_when_negated
        "Expected #{@attribute} to not contains a valid xml, but it is #{attribute_output.inspect}"
      end

      protected

      def valid_xml?
        return false unless attribute_output

        @given_record.valid?

        !@given_record.errors[@attribute].include?(@expected_message)
      end

      def valid_xml_based_on_schema?
        return true if @schema.nil?

        @given_record.valid?

        !@given_record.errors[@attribute].include?(@expected_message)
      end

      def attribute_output
        @given_record.send(@attribute)
      end
    end

    def validate_xml_of(*args)
      ValidateXmlOf.new(*args)
    end
  end
end
