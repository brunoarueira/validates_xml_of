require "spec_helper"
require "validates_xml_of/matchers/validate_xml_of"

class Post
  include ::ActiveModel::Validations

  attr_accessor :content, :content2, :number

  validates :content, xml: true
  validates :content2, xml: { schema: 'Schema', message: 'the schema used not validate this' }
end

RSpec.configure do |config|
  config.include ValidatesXmlOf::Matchers
end

describe Post do
  before do
    subject.content = '<?xml version="1.0"?><foo></foo>'
    subject.content2 = '<?xml version="1.0"?><Bar><foo><foo_bar value="baz" /></foo></Bar>'
  end

  it { should validate_xml_of(:content) }
  it { should validate_xml_of(:content2).with_schema('Schema').with_message('the schema used not validate this') }
  it { should_not validate_xml_of(:number) }

  context 'invalid behaviour' do
    before do
      subject.content = ''
      subject.content2 = '<?xml version="1.0"?><Bar><foo><foo_bar value="baz" /></foo></Bar>'
    end

    it 'expect an error since content is empty' do
      expect {
        should validate_xml_of(:content)
      }.to raise_error("Expected content to contains a valid xml, but it is \"\"")
    end

    it 'expect an error since content2 is a xml' do
      expect {
        should_not validate_xml_of(:content2).with_schema('Schema')
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError,
                       'Expected content2 to not contains a valid xml, but it is "<?xml version=\"1.0\"?><Bar><foo><foo_bar value=\"baz\" /></foo></Bar>"')
    end
  end
end
