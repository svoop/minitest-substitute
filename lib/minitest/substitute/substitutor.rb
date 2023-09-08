# frozen_string_literal: true

module Minitest
  module Substitute
    class Substitutor

      attr_writer :on

      def initialize(target, on:)
        @target, @on = target, on
      end

      def substitute(value)
        @substitute = value unless instance_variable_defined? :@substitute
        self
      end

      def commit
        @original = get
        set @substitute
      end

      def rollback
        set @original
      end

      private

      def get
        case @target
        when /^@@/   # class variable
          @on.class_eval @target.to_s
        else   # constant, instance or global variable
          @on.instance_eval @target.to_s
        end
      end

      def set(value)
        case @target
        when /^::/
          remove_const @target
          eval "#{@target} = value"
        when /^@@/   # class variable
          @on.class_eval "#{@target} = value"
        else    # instance or global variable
          @on.instance_eval "#{@target} = value"
        end
      end

      # Remove constant without warning
      def remove_const(const)
        namespace, _, name = const.rpartition('::')
        receiver = namespace == '' ? Object : Object.const_get(namespace)
        receiver.send(:remove_const, name)
      end

    end
  end
end
