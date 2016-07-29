require 'spec_helper'
require 'validates_xml_of/active_model'

describe ActiveModel::Validations::XmlValidator do
  let(:content) { |example| example.description }
  let(:content2) { |example| example.description }

  describe 'validate without schema' do
    subject do |example|
      class Person
        include ActiveModel::Validations

        attr_reader :content, :content2

        def initialize(content, content2 = nil)
          @content = content.freeze
          @content2 = content2.freeze
        end

        validates :content, xml: true

        validates_xml_of :content2, allow_blank: true
      end

      Person.new(example.example_group_instance.content).tap(&:valid?).errors.full_messages
    end

    context 'valid' do
      it '<?xml version="1.0"?><foo></foo>' do
        expect(subject).to be_empty
      end

      it '<?xml version="1.0"?><foo value="10" />' do
        expect(subject).to be_empty
      end
    end

    context 'invalid' do
      it '<?xml version="1.0"?><foo' do
        expect(subject).to include 'Content does not appear to be a valid xml'
      end

      it '<?xml version="1.0"?><foo>' do
        expect(subject).to include 'Content does not appear to be a valid xml'
      end
    end
  end

  describe 'validate with schema' do
    subject do |example|
      class Person
        include ActiveModel::Validations

        attr_reader :content, :content2

        def initialize(content, content2 = nil)
          @content = content.freeze
          @content2 = content2.freeze
        end

        validates :content, xml: { schema: 'Schema' }

        validates_xml_of :content2, schema: 'Schema', allow_blank: true
      end

      Person.new(example.example_group_instance.content).tap(&:valid?).errors.full_messages
    end

    before do
      ValidatesXmlOf.setup do |config|
        config.schema_paths = "examples/xsds"
      end
    end

    context 'valid' do
      it '<?xml version="1.0"?><Bar><foo><foo_bar value="baz" /></foo></Bar>' do
        expect(subject).to be_empty
      end
    end

    context 'invalid' do
      it '<?xml version="1.0"?><foo' do
        expect(subject).to include 'Content does not appear to be a valid xml'
      end

      it '<?xml version="1.0"?><foo>' do
        expect(subject).to include 'Content does not appear to be a valid xml'
      end
    end
  end
end
