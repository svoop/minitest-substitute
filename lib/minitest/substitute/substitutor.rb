# frozen_string_literal: true

module Minitest
  module Substitute
    class Substitutor

      EVAL_METHODS = [:instance_eval, :instance_eval, :class_eval].freeze

      attr_writer :on

      def initialize(variable, substitute, on:)
        @variable, @substitute, @on = variable, substitute, on
      end

      def commit
        @original = get
        set @substitute
      end

      def rollback
        set @original
      end

      private

      def eval_method
        EVAL_METHODS[@variable.count('@')]
      end

      def get
        @on.send(eval_method, @variable.to_s)
      end

      def set(value)
        @on.send(eval_method, "#{@variable} = value")
      end

    end
  end
end
