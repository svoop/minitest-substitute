# frozen_string_literal: true

require_relative '../../../spec_helper'
require_relative '../../../factory'

describe :with do
  10.times do   # test value reset even though order is random
    describe "instance variable" do
      context 'untouched' do
        it "returns the original value" do
          _($_spec_config_instance.instance_variable_get(:@version)).must_equal 1
        end
      end

      context 'substituted' do
        with '@version', 2, on: $_spec_config_instance

        it "returns the substitute value" do
          _($_spec_config_instance.instance_variable_get(:@version)).must_equal 2
        end
      end
    end
  end

  10.times do   # test value reset even though order is random
    describe "global variable" do
      context 'untouched' do
        it "returns the original value" do
          _($_spec_global_variable).must_equal :original
        end
      end

      context 'substituted' do
        with "$_spec_global_variable", 'oggy'

        it "returns the substitute value" do
          _($_spec_global_variable).must_equal 'oggy'
        end
      end
    end
  end

  10.times do   # test value reset even though order is random
    describe "environment variable" do
      context 'untouched' do
        it "returns the original value" do
          _(ENV['WITH_SPEC_ENV_VAR']).must_be :nil?
        end
      end

      context 'substituted' do
        with "ENV['WITH_SPEC_ENV_VAR']", 'foobar'

        it "returns the substitute value" do
          _(ENV['WITH_SPEC_ENV_VAR']).must_equal 'foobar'
        end
      end
    end
  end

  10.times do   # test value reset even though order is random
    describe "multiple substitutions" do
      context 'untouched' do
        it "returns the original values" do
          _($_spec_config_instance.instance_variable_get(:@version)).must_equal 1
          _($_spec_config_instance.instance_variable_get(:@released_on)).must_equal '2023-08-24'
        end
      end

      context 'substituted' do
        with '@version', 2, on: $_spec_config_instance
        with '@released_on', on: $_spec_config_instance do
          '2012-12-12'
        end

        it "returns the substitute values" do
          _($_spec_config_instance.instance_variable_get(:@version)).must_equal 2
          _($_spec_config_instance.instance_variable_get(:@released_on)).must_equal '2012-12-12'
        end
      end
    end
  end
end
