# frozen_string_literal: true

require_relative '../../../spec_helper'
require_relative '../../../factory'

describe Minitest::Substitute::Substitutor do

  describe :substitute do
    subject do
      Minitest::Substitute::Substitutor.new('@version', on: $_spec_config_instance)
    end

    it "memoizes nil substitution values" do
      _(subject.substitute(nil).instance_variable_get(:@substitute)).must_be :nil?
      _(subject.substitute(:ignored).instance_variable_get(:@substitute)).must_be :nil?
    end

    it "memoizes any other substitution values" do
      _(subject.substitute(42).instance_variable_get(:@substitute)).must_equal 42
      _(subject.substitute(:ignored).instance_variable_get(:@substitute)).must_equal 42
    end
  end

end
