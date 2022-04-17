# frozen_string_literal: true

require 'spec_helper'
require 'validates_xml_of/active_model'

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

class PersonWithSchema
  include ActiveModel::Validations

  attr_reader :content, :content2

  def initialize(content, content2 = nil)
    @content = content.freeze
    @content2 = content2.freeze
  end

  validates :content, xml: { schema: 'Schema' }
  validates_xml_of :content2, schema: 'Schema', allow_blank: true
end

describe ActiveModel::Validations::XmlValidator do
  describe 'validate without schema' do
    context 'valid' do
      it '<?xml version="1.0"?><foo></foo>' do |example|
        subject = Person.new(example.description)

        subject.valid?

        expect(subject.errors.full_messages).to be_empty
      end

      it '<?xml version="1.0"?><foo value="10" />' do |example|
        subject = Person.new(example.description)

        subject.valid?

        expect(subject.errors.full_messages).to be_empty
      end
    end

    context 'invalid' do
      it '<?xml version="1.0"?><foo' do |example|
        subject = Person.new(example.description)

        subject.valid?

        expect(subject.errors.full_messages).to include 'Content does not appear to be a valid xml'
      end

      it '<?xml version="1.0"?><foo>' do |example|
        subject = Person.new(example.description)

        subject.valid?

        expect(subject.errors.full_messages).to include 'Content does not appear to be a valid xml'
      end
    end
  end

  describe 'validate with schema' do
    before do
      ValidatesXmlOf.setup do |config|
        config.schema_paths = 'examples/xsds'
      end
    end

    context 'valid' do
      it '<?xml version="1.0"?><Bar><foo><foo_bar value="baz" /></foo></Bar>' do |example|
        subject = PersonWithSchema.new(example.description)

        subject.valid?

        expect(subject.errors.full_messages).to be_empty
      end
    end

    context 'invalid' do
      it '<?xml version="1.0"?><foo' do |example|
        subject = PersonWithSchema.new(example.description)

        subject.valid?

        expect(subject.errors.full_messages).to include 'Content does not appear to be a valid xml'
      end

      it '<?xml version="1.0"?><foo>' do |example|
        subject = PersonWithSchema.new(example.description)

        subject.valid?

        expect(subject.errors.full_messages).to include 'Content does not appear to be a valid xml'
      end
    end
  end
end
