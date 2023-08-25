# frozen_string_literal: true

require_relative '../../../spec_helper'
require_relative '../../../factory'

describe :with do
  10.times do   # test rollback even though order is random
    describe "instance variable" do
      subject do
        Config.new
      end

      context 'untouched' do
        it "returns the original value" do
          _(subject.instance_variable_get(:@version)).must_equal 1
        end
      end

      context 'substituted' do
        with '@version', 2

        it "returns the substitute value" do
          _(subject.instance_variable_get(:@version)).must_equal 2
        end
      end
    end
  end

  10.times do   # test rollback even though order is random
    describe "class variable" do
      subject do
        Config
      end

      context 'untouched' do
        it "returns the original value" do
          _(subject.class_variable_get(:@@counter)).must_equal 0
        end
      end

      context 'substituted' do
        with '@@counter', 42

        it "returns the substitute value" do
          _(subject.class_variable_get(:@@counter)).must_equal 42
        end
      end
    end
  end

10.times do   # test rollback even though order is random
    describe "global variable" do
      context 'untouched' do
        it "returns the original value" do
          _($spec_global_variable).must_equal :original
        end
      end

      context 'substituted' do
        with "$spec_global_variable", 'oggy'

        it "returns the substitute value" do
          _($spec_global_variable).must_equal 'oggy'
        end
      end
    end
  end

  10.times do   # test rollback even though order is random
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

  10.times do   # test rollback even though order is random
    describe "multiple substitutions" do
      subject do
        Config.new
      end

      context 'untouched' do
        it "returns the original values" do
          _(subject.instance_variable_get(:@version)).must_equal 1
          _(subject.instance_variable_get(:@released_on)).must_equal '2023-08-24'
        end
      end

      context 'substituted' do
        with '@version', 2
        with '@released_on' do
          '2012-12-12'
        end

        it "returns the substitute values" do
          _(subject.instance_variable_get(:@version)).must_equal 2
          _(subject.instance_variable_get(:@released_on)).must_equal '2012-12-12'
        end
      end
    end
  end
end
