# ValidatesXmlOf

[![Build Status](https://travis-ci.org/brunoarueira/validates_xml_of.svg?branch=master)](https://travis-ci.org/brunoarueira/validates_xml_of)
[![Code Climate](https://codeclimate.com/github/brunoarueira/validates_xml_of/badges/gpa.svg)](https://codeclimate.com/github/brunoarueira/validates_xml_of)
[![Test Coverage](https://codeclimate.com/github/brunoarueira/validates_xml_of/badges/coverage.svg)](https://codeclimate.com/github/brunoarueira/validates_xml_of/coverage)

Validates if a given string contains a valid xml and validates based on defined
schema too.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'validates_xml_of'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validates_xml_of

## Usage

### Rails

If you do not want to use xsd:

```
class Post < ActiveRecord::Base
  ...

  validates :content, xml: true

  ...
end
```

And if you want to use xsd, you will need to define an initializer to setup a path for your schemas:

```
ValidatesXmlOf.setup do |configure|
  config.schema_paths = "lib/xsds"
end
```

After, you need to set your validation to specify what schema you are looking for:

```
class Post < ActiveRecord::Base
  ...
  # The schema must be in lib/xsds/Schema.xsd
  validates :content, xml: { schema: 'Schema' }
  ...
end
```

***PS:*** Coming soon, I will implement a generator to create this initializer

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brunoarueira/validates_xml. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

