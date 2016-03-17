require 'spec_helper'

describe ValidatesXml::Validator do
  before do
    I18n.enforce_available_locales = false

    I18n.locale = :en
  end

  describe '#validate' do
    context 'returns the invalid message' do
      let(:malformed_xml) { '<?xml version="1.0"?><foo' }

      it 'when not informed a xml' do
        validator = described_class.new(nil)

        expect(validator.validate).to eq 'does not appear to be a valid xml'
      end

      it 'when informed a malformed xml' do
        validator = described_class.new(malformed_xml)

        expect(validator.validate).to eq 'does not appear to be a valid xml'
      end

      it 'customized' do
        validator = described_class.new(malformed_xml, message: 'it is not a xml')

        expect(validator.validate).to eq 'it is not a xml'
      end
    end

    context 'returns the invalid message based on schema' do
      let(:formed_xml) { '<?xml version="1.0"?><foo></foo>' }

      before do
        ValidatesXml.schema_paths = "examples/xsds"
      end

      it 'when informed an invalid xml from the schema point of view' do
        validator = described_class.new(formed_xml, schema: 'Schema')

        expect(validator.validate).to eq 'does not appear to be a valid xml based on schema informed'
      end

      it 'customized' do
        validator = described_class.new(formed_xml, schema: 'Schema', schema_message: 'the xml is malformed')

        expect(validator.validate).to eq 'the xml is malformed'
      end
    end

    context 'returns nil' do
      let(:formed_xml) { '<?xml version="1.0"?><foo></foo>' }

      before do
        ValidatesXml.schema_paths = "examples/xsds"
      end

      it 'when xml is well formed' do
        validator = described_class.new(formed_xml)

        expect(validator.validate).to be_nil
      end

      it 'when xml is well formed from the schema point of view' do
        formed_xml_based_schema = '<?xml version="1.0"?><Bar><foo><foo_bar value="baz" /></foo></Bar>'

        validator = described_class.new(formed_xml_based_schema, schema: 'Schema')

        expect(validator.validate).to be_nil
      end
    end
  end
end
