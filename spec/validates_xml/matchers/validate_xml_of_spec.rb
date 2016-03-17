require "spec_helper"
require "validates_xml/matchers/validate_xml_of"

class Post
  include ::ActiveModel::Validations

  attr_accessor :content, :content2, :number

  validates :content, xml: true
  validates :content2, xml: { schema: 'Schema' }
end

RSpec.configure do |config|
  config.include ValidatesXml::Matchers
end

describe Post do
  before do
    subject.content = '<?xml version="1.0"?><foo></foo>'
    subject.content2 = '<?xml version="1.0"?><Bar><foo><foo_bar value="baz" /></foo></Bar>'
  end

  it { should validate_xml_of(:content) }
  it { should validate_xml_of(:content2).with_schema('Schema') }
  it { should_not validate_xml_of(:number) }
end
