# frozen_string_literal: true

module Minitest
  module Substitute
    module With
      @original = {}
      class << self
        attr_accessor :original
      end

      # Substitute the variable value for the duration of the given block
      #
      # @param variable [String] instance or global variable name
      # @param substitute [Object] temporary substitution value
      # @param on [Object, nil] substitute in the context of this object
      # @yield block during which the substitution is made
      # @return [Object] return value of the yielded block
      def with(variable, substitute, on: self)
        commit_substitution(variable, substitute, on: on)
        yield.tap do
          rollback_substitution(variable, on: on)
        end
      end

      private

      def commit_substitution(variable, substitute, on:)
        Minitest::Substitute::With.original[variable.hash] = on.instance_eval variable.to_s
        on.instance_eval "#{variable} = substitute"
      end

      def rollback_substitution(variable, on:)
        on.instance_eval "#{variable} = Minitest::Substitute::With.original.delete(variable.hash)"
      end
    end
  end
end
