# frozen_string_literal: true

require_relative '../../../spec_helper'
require_relative '../../../factory'

describe :eval_method do
  subject do
    Minitest::Substitute::Substitutor
  end

  it "returns instance_eval for instance variables" do
    _(subject.new('@version', nil, on: $_spec_config_instance).send(:eval_method)).must_equal :instance_eval
  end

  it "returns class_eval for class variables" do
    _(subject.new('@@counter', nil, on: Config).send(:eval_method)).must_equal :class_eval
  end

  it "returns instance_eval for global variables" do
    _(subject.new('$foobar', nil, on: Object).send(:eval_method)).must_equal :instance_eval
  end

  it "returns instance_eval for global accessors" do
    _(subject.new('ENV', nil, on: Object).send(:eval_method)).must_equal :instance_eval
  end
end
