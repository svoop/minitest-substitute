# frozen_string_literal: true

module Minitest
  module Substitute
    module With

      # Substitute the variable value for the duration of the given block
      #
      # @param variable [String] instance or global variable name
      # @param substitute [Object] temporary substitution value
      # @param on [Object, nil] substitute in the context of this object
      # @yield block during which the substitution is made
      # @return [Object] return value of the yielded block
      def with(variable, substitute, on: self)
        substitutor = Minitest::Substitute::Substitutor.new(variable, on: on).substitute(substitute)
        substitutor.commit
        yield.tap do
          substitutor.rollback
        end
      end

    end
  end
end
