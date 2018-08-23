# frozen_string_literal: true

module ShareNotify
  class RuntimeError < ::RuntimeError
  end

  class InitializationError < RuntimeError
    def initialize(context, method_names)
      super("Expected #{context.inspect} to respond to #{method_names.inspect}")
    end
  end
end
