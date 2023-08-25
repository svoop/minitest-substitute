# frozen_string_literal: true

require 'minitest/spec'

Minitest::Spec::DSL.class_eval do

  # Substitute the variable value for the duration of the current description
  #
  # @param variable [String] instance or global variable name
  # @param substitute [Object] temporary substitution value
  # @param on [Object, Symbol, nil] substitute in the context of this object
  #   or in the context of the declared subject if +:subject+ is set
  # @yield temporary substitution value (takes precedence over +substitute+ param)
  def with(variable, substitute=nil, on: :subject)
    substitute = yield if block_given?
    substitutor = Minitest::Substitute::Substitutor.new(variable, substitute, on: on)
    before do
      substitutor.on = subject if on == :subject && respond_to?(:subject)
      substitutor.commit
    end
    after do
      substitutor.rollback
    end
  end

  # Minitest does not support multiple before/after blocks
  remove_method :before
  def before(_type=nil, &block)
    include(Module.new do
      define_method(:setup) do
        super()
        instance_eval &block
      end
    end) # .then &:include
  end

  remove_method :after
  def after(_type=nil, &block)
    include(Module.new do
      define_method(:teardown) do
        instance_eval &block
      ensure
        super()
      end
    end)  #.then &:include
  end

end
