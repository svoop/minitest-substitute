# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Minitest::Substitute::VERSION do
  it "must be defined" do
    _(Minitest::Substitute::VERSION).wont_be_nil
  end
end
