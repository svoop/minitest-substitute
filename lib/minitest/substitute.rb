# frozen_string_literal: true

require_relative 'substitute/version'

require_relative 'substitute/substitutor'
require_relative 'substitute/substitute'
require_relative 'substitute/spec'

include Minitest::Substitute::Substitute
