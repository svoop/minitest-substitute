# frozen_string_literal: true

require_relative 'substitute/version'

require_relative 'substitute/substitutor'
require_relative 'substitute/with'
require_relative 'substitute/spec'

include Minitest::Substitute::With
