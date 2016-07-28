require 'spec_helper'
require 'i18n'

describe ValidatesXmlOf do
  describe 'setup' do
    it 'set schema_paths through setup block' do
      ValidatesXmlOf.setup do |config|
        config.schema_paths = "examples/xsds"
      end

      expect(ValidatesXmlOf.schema_paths).to eq "examples/xsds"
    end
  end

  describe '.default_message' do
    context 'without i18n' do
      before do
        expect(subject).to receive(:i18n_defined?).and_return(false)
      end

      it 'returns the DEFAULT_MESSAGE constant' do
        expect(ValidatesXmlOf.default_message).to eq 'does not appear to be a valid xml'
      end
    end

    context 'with i18n' do
      before do
        expect(I18n).to receive(:t).with(any_args).and_return('is not a xml')
      end

      it 'returns the i18n defined message' do
        expect(ValidatesXmlOf.default_message).to eq 'is not a xml'
      end
    end
  end

  describe '.default_schema_message' do
    context 'without i18n' do
      before do
        expect(subject).to receive(:i18n_defined?).and_return(false)
      end

      it 'returns the DEFAULT_SCHEMA_MESSAGE constant' do
        expect(ValidatesXmlOf.default_schema_message).to eq 'does not appear to be a valid xml based on schema informed'
      end
    end

    context 'with i18n' do
      before do
        expect(I18n).to receive(:t).with(any_args).and_return('xml input is not valid for the schema')
      end

      it 'returns the i18n defined message' do
        expect(ValidatesXmlOf.default_message).to eq 'xml input is not valid for the schema'
      end
    end
  end

  describe '.lookup_schema_file' do
    context 'with nil, empty or invalid schema path' do
      it 'returns nil when the path is nil' do
        ValidatesXmlOf.schema_paths = nil

        expect(ValidatesXmlOf.lookup_schema_file('Schema')).to be_nil
      end

      it 'returns nil with inexistent path' do
        ValidatesXmlOf.schema_paths = 'erroneous_path/xsds'

        expect(ValidatesXmlOf.lookup_schema_file('Schema')).to be_nil
      end
    end

    context 'based on the schema name' do
      it 'returns nil if the schema is not found' do
        ValidatesXmlOf.schema_paths = 'examples/xsds'

        expect(ValidatesXmlOf.lookup_schema_file('Schema2')).to be_nil
      end

      it 'returns the schema file with one schema path informed' do
        ValidatesXmlOf.schema_paths = 'examples/xsds'

        lookup_schema_file = IO.read(ValidatesXmlOf.lookup_schema_file('Schema'))
        compared_file = IO.read(File.new('examples/xsds/Schema.xsd'))

        expect(lookup_schema_file).to eq compared_file
      end

      it 'returns the schema file with multiple schema paths informed' do
        ValidatesXmlOf.schema_paths = ['examples/xsds', nil]

        lookup_schema_file = IO.read(ValidatesXmlOf.lookup_schema_file('Schema'))
        compared_file = IO.read(File.new('examples/xsds/Schema.xsd'))

        expect(lookup_schema_file).to eq compared_file
      end

      it 'returns the schema file with some invalid schema path' do
        ValidatesXmlOf.schema_paths = ['examples/xsds', 'erroneous_path/xsds']

        lookup_schema_file = IO.read(ValidatesXmlOf.lookup_schema_file('Schema'))
        compared_file = IO.read(File.new('examples/xsds/Schema.xsd'))

        expect(lookup_schema_file).to eq compared_file
      end
    end
  end
end
