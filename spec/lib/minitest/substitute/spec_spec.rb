# frozen_string_literal: true

require_relative '../../../spec_helper'
require_relative '../../../factory'

describe Minitest::Spec::DSL do

  describe :substitute do
    10.times do   # test rollback even though order is random
      describe "class declaring constant" do
        context 'untouched' do
          it "returns the original value" do
            _(Dog.makes).must_equal 'woof'
          end
        end

        context 'substituted' do
          substitute '::Dog', Cat

          it "returns the substitute value" do
            _(Dog.makes).must_equal 'meow'
          end
        end
      end
    end

    10.times do   # test rollback even though order is random
      describe "other constant" do
        context 'untouched' do
          it "returns the original value" do
            _(Plane::TYPES).must_equal ['Glider']
          end
        end

        context 'substituted' do
          substitute 'Plane::TYPES', ['Piston', 'Jet']

          it "returns the substitute value" do
            _(Plane::TYPES).must_equal ['Piston', 'Jet']
          end
        end
      end
    end

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
          substitute '@version', 2

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
            _(Config.class_variable_get(:@@counter)).must_equal 0
          end
        end

        context 'substituted' do
          substitute '@@counter', 42

          it "returns the substitute value" do
            _(Config.class_variable_get(:@@counter)).must_equal 42
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
          substitute "$spec_global_variable", 'oggy'

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
          substitute "ENV['WITH_SPEC_ENV_VAR']", 'foobar'

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
          substitute '@version', 2
          substitute '@released_on' do
            '2012-12-12'
          end

          it "returns the substitute values" do
            _(subject.instance_variable_get(:@version)).must_equal 2
            _(subject.instance_variable_get(:@released_on)).must_equal '2012-12-12'
          end
        end
      end
    end

    10.times do   # test rollback even though order is random
      describe "let helper value in substitute block" do
        subject do
          Config.new
        end

        let :release_date do
          '2011-11-11'
        end

        substitute '@released_on' do
          release_date
        end

        it "returns the helper value" do
          _(subject.instance_variable_get(:@released_on)).must_equal '2011-11-11'
        end
      end
    end
  end

end
