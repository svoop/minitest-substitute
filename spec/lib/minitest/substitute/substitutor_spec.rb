# frozen_string_literal: true

require_relative '../../../spec_helper'
require_relative '../../../factory'

describe :substitute do
  subject do
    Minitest::Substitute::Substitutor.new('@version', on: $_spec_config_instance)
  end

  it "memoizes nil substitution values" do
    _(subject.substitute(nil).instance_variable_get(:@substitute)).must_equal nil
    _(subject.substitute(:ignored).instance_variable_get(:@substitute)).must_equal nil
  end

  it "memoizes any other substitution values" do
    _(subject.substitute(42).instance_variable_get(:@substitute)).must_equal 42
    _(subject.substitute(:ignored).instance_variable_get(:@substitute)).must_equal 42
  end
end

describe :eval_method do
  subject do
    Minitest::Substitute::Substitutor
  end

  it "returns instance_eval for instance variables" do
    _(subject.new('@version', on: $_spec_config_instance).send(:eval_method)).must_equal :instance_eval
  end

  it "returns class_eval for class variables" do
    _(subject.new('@@counter', on: Config).send(:eval_method)).must_equal :class_eval
  end

  it "returns instance_eval for global variables" do
    _(subject.new('$foobar', on: Object).send(:eval_method)).must_equal :instance_eval
  end

  it "returns instance_eval for global accessors" do
    _(subject.new('ENV', on: Object).send(:eval_method)).must_equal :instance_eval
  end
end
