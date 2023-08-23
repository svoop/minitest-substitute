[![Version](https://img.shields.io/gem/v/minitest-substitute.svg?style=flat)](https://rubygems.org/gems/minitest-substitute)
[![Tests](https://img.shields.io/github/actions/workflow/status/svoop/minitest-substitute/test.yml?style=flat&label=tests)](https://github.com/svoop/minitest-substitute/actions?workflow=Test)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/svoop/minitest-substitute.svg?style=flat)](https://codeclimate.com/github/svoop/minitest-substitute/)
[![Donorbox](https://img.shields.io/badge/donate-on_donorbox-yellow.svg)](https://donorbox.org/bitcetera)

# Minitest::Substitute

Simple Minitest helper to replace values such as an instance variable of an object or an environment variable for the duration of a block or a group of tests.

This comes in very handy when you have to derive from default configuration in order to test some aspects of your code.

* [Homepage](https://github.com/svoop/minitest-substitute)
* [API](https://www.rubydoc.info/gems/minitest-substitute)
* Author: [Sven Schwyn - Bitcetera](https://bitcetera.com)

## Install

This gem is [cryptographically signed](https://guides.rubygems.org/security/#using-gems) in order to assure it hasn't been tampered with. Unless already done, please add the author's public key as a trusted certificate now:

```
gem cert --add <(curl -Ls https://raw.github.com/svoop/minitest-substitute/main/certs/svoop.pem)
```

Add the following to the <tt>Gemfile</tt> or <tt>gems.rb</tt> of your [Bundler](https://bundler.io) powered Ruby project:

```ruby
gem 'minitest-substitute'
```

And then install the bundle:

```
bundle install --trust-policy MediumSecurity
```

Finally, require this gem in your `test_helper.rb` or `spec_helper.rb`:

```ruby
require 'minitest/substitute'
```

## Usage

This lightweight gem implements features on a "as needed" basis, as of now:

* substitution of instance variables
* substitution of global variables

Please [create an issue describing your use case](https://github.com/svoop/minitest-substitute/issues) in case you need more features such as the substitution of class variables or substitution via accessor methods.

### Block

To substitute the value of an instance variable for the duration of a block:

```ruby
class Config
  def initialize
    @version = 1
  end
end

Config.instance_variable_get('@version')     # => 1
with '@version', 2, on: Config do
  Config.instance_variable_get('@version')   # => 2
end
Config.instance_variable_get('@version')     # => 1
```

Same goes for global variables:

```ruby
$verbose = false   # => false
with '$verbose', true do
  $verbose         # => true
end
$verbose           # => false
```

And it works for hashes as well which comes in handy when you have to temporarily override the value of an environment variable:

```ruby
ENV['EDITOR']     # => 'vi'
with "ENV['EDITOR']", 'nano' do
  ENV['EDITOR']   # => 'nano'
end
ENV['EDITOR']     # => 'vi'
```

It's safe to nest multiple `with` statements.

### Group of Tests

When using spec notation, you can change a value for all tests within a `describe` group:

```ruby
class Config
  def initialize
    @version = 1
  end
end

describe Config do
  subject do
    Config.new
  end

  describe 'original version' do
    it "returns the original version" do
      _(subject.instance_variable_get('@version')).must_equal 1
    end
  end

  describe 'sustituted version' do
    with '@version', 2, on: Config

    it "returns the substituted version" do
      _(subject.instance_variable_get('@version')).must_equal 2
    end
  end
end
```

For consistency with other Minitest helpers, the following alternative does exactly the same:

```ruby
with '@version', on: Config do
  2
end
```

It's safe to use multiple `with` statements within one `describe` block.

(The spec integration is borrowed from [minitest-around](https://rubygems.org/gems/minitest-around) for elegance and compatibility.)

## Development

To install the development dependencies and then run the test suite:

```
bundle install
bundle exec rake    # run tests once
bundle exec guard   # run tests whenever files are modified
```

You're welcome to [submit issues](https://github.com/svoop/minitest-substitute/issues) and contribute code by [forking the project and submitting pull requests](https://docs.github.com/en/get-started/quickstart/fork-a-repo).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).