require 'spec_helper'
require 'i18n'

describe ValidatesXml do
  describe 'setup' do
    it 'set schema_paths through setup block' do
      ValidatesXml.setup do |config|
        config.schema_paths = "examples/xsds"
      end

      expect(ValidatesXml.schema_paths).to eq "examples/xsds"
    end
  end

  describe '.default_message' do
    context 'without i18n' do
      before do
        expect(subject).to receive(:i18n_defined?).and_return(false)
      end

      it 'returns the DEFAULT_MESSAGE constant' do
        expect(ValidatesXml.default_message).to eq 'does not appear to be a valid xml'
      end
    end

    context 'with i18n' do
      before do
        expect(I18n).to receive(:t).with(any_args).and_return('is not a xml')
      end

      it 'returns the i18n defined message' do
        expect(ValidatesXml.default_message).to eq 'is not a xml'
      end
    end
  end

  describe '.default_schema_message' do
    context 'without i18n' do
      before do
        expect(subject).to receive(:i18n_defined?).and_return(false)
      end

      it 'returns the DEFAULT_SCHEMA_MESSAGE constant' do
        expect(ValidatesXml.default_schema_message).to eq 'does not appear to be a valid xml based on schema informed'
      end
    end

    context 'with i18n' do
      before do
        expect(I18n).to receive(:t).with(any_args).and_return('xml input is not valid for the schema')
      end

      it 'returns the i18n defined message' do
        expect(ValidatesXml.default_message).to eq 'xml input is not valid for the schema'
      end
    end
  end
end
