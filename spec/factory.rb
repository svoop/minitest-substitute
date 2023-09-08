# frozen_string_literal: true

class Config
  def initialize
    @version = 1
    @released_on = '2023-08-24'
  end

  @@counter = 0
end

module Dog
  def self.makes
    'woof'
  end
end

module Cat
  def self.makes
    'meow'
  end
end

module Plane
  TYPES = ['Glider'].freeze
end

$spec_global_variable = :original
