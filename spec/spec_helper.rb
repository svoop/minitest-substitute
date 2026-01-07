# frozen_string_literal: true

gem 'minitest'

require 'pathname'
require 'debug'

require 'minitest/autorun'
require Pathname(__dir__).join('..', 'lib', 'minitest', 'substitute')

class Minitest::Spec
  class << self
    alias_method :context, :describe
  end
end
