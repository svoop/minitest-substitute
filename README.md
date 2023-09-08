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
gem cert --add <(curl -Ls https://bitcetera.com/downloads/gem-public_cert.pem)
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

### Block

To substitute the value of an instance variable for the duration of a block:

```ruby
class Config
  def initialize
    @version = 1
  end
end

config = Config.new

config.instance_variable_get('@version')     # => 1
with '@version', 2, on: config do
  config.instance_variable_get('@version')   # => 2
end
config.instance_variable_get('@version')     # => 1
```

:warning: The target `on` is set explicitly in this case. If you omit this argument, `self` will be used as target by default.

Class variables can be substituted as well:

```ruby
class Config
  @@counter = 0
end

Config.class_variable_get('@@counter')     # => 0
with '@@counter', 42, on: Config do
  Config.class_variable_get('@@counter')   # => 42
end
Config.class_variable_get('@@counter')     # => 0
```

Same goes for global variables:

```ruby
$verbose = false   # => false
with '$verbose', true do
  $verbose         # => true
end
$verbose           # => false
```

And it works for globals like `ENV` as well which comes in handy when you have to temporarily override the value of an environment variable:

```ruby
ENV['EDITOR']     # => 'vi'
with "ENV['EDITOR']", 'nano' do
  ENV['EDITOR']   # => 'nano'
end
ENV['EDITOR']     # => 'vi'
```

You can even substitute constants, however, you have to use their absolute name starting with `::`:

```ruby
module Animals
  DOG_MAKES = 'woof'
  CAT_MAKES = 'meow'
end

Animals::DOG_MAKES     # => 'woof'
with '::Animals::DOG_MAKES', Animals::CAT_MAKES do
  Animals::DOG_MAKES   # => 'meow'
end
Animals::DOG_MAKES     # => 'woof'
```

Remember that class declarations are assigned to constants as well:

```ruby
class Dog
  self.makes
    'woof'
  end
end

class Cat
  self.makes
    'meow'
  end
end

Dog.makes     # => 'woof'
with '::Dog', Cat do
  Dog.makes   # => 'meow'
end
Dog.makes     # => 'woof'
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

:warning: The target `on` is set explicitly in this case. If you omit this argument, `:subject` will be used as target by default which refers to the subject defined by the `subject {}` helper.

Alternatively, you can pass the substitution value as a block. This block will be evaluated once in the context of the test, in other words, you can use assignments done with `let` inside the block:

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

  let :version do
    2
  end

  describe 'original version' do
    it "returns the original version" do
      _(subject.instance_variable_get('@version')).must_equal 1
    end
  end

  describe 'sustituted version' do
    with '@version', on: Config do
      version   # set using "let" above
    end

    it "returns the substituted version" do
      _(subject.instance_variable_get('@version')).must_equal 2
    end
  end
end
```

If both a substitution value and a substitution block are present, the latter takes precedence.

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
