# frozen_string_literal: true

require_relative '../../../spec_helper'
require_relative '../../../factory'

describe Minitest::Substitute::With do

  describe :with do


    describe "class declaring constant" do
      it "substitutes the class for the duration of a block" do
        _(Dog.makes).must_equal 'woof'
        with '::Dog', Cat do
          _(Dog.makes).must_equal 'meow'
        end
        _(Dog.makes).must_equal 'woof'
      end
    end

    describe "other constant" do
      it "returns the substitute value" do
        _(Plane::TYPES).must_equal ['Glider']
        with 'Plane::TYPES', ['Piston', 'Jet'] do
          _(Plane::TYPES).must_equal ['Piston', 'Jet']
        end
        _(Plane::TYPES).must_equal ['Glider']
      end
    end


    describe "instance variable" do
      it "substitutes the value for the duration of a block" do
        config = Config.new
        _(config.instance_variable_get(:@version)).must_equal 1
        with '@version', 2, on: config do
          _(config.instance_variable_get(:@version)).must_equal 2
        end
        _(config.instance_variable_get(:@version)).must_equal 1
      end
    end

    describe "class variable" do
      it "substitutes the value for the duration of a block" do
        _(Config.class_variable_get(:@@counter)).must_equal 0
        with '@@counter', 42, on: Config do
          _(Config.class_variable_get(:@@counter)).must_equal 42
        end
        _(Config.class_variable_get(:@@counter)).must_equal 0
      end
    end

    describe "global variable" do
      it "substitutes the value for the duration of a block" do
        _($spec_global_variable).must_equal :original
        with "$spec_global_variable", 'oggy' do
          _($spec_global_variable).must_equal 'oggy'
        end
        _($spec_global_variable).must_equal :original
      end
    end

    describe "environment variable" do
      it "substitutes the value for the duration of a block" do
        _(ENV['WITH_SPEC_ENV_VAR']).must_be :nil?
        with "ENV['WITH_SPEC_ENV_VAR']", 'foobar' do
          _(ENV['WITH_SPEC_ENV_VAR']).must_equal 'foobar'
        end
        _(ENV['WITH_SPEC_ENV_VAR']).must_be :nil?
      end
    end

    describe "nested substitutions" do
      it "substitutes the values for the duration of a block" do
        config = Config.new
        with '@version', 2, on: config do
          with '@released_on', '2012-12-12', on: config do
            _(config.instance_variable_get(:@version)).must_equal 2
            _(config.instance_variable_get(:@released_on)).must_equal '2012-12-12'
          end
        end
      end
    end
  end

end
