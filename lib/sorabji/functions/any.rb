module Sorabji
  class FunctionAnyNode < FunctionNode
    def to_ast
      list = args.to_ast
      # unless list.elements.count == 1
      #   raise ArgumentError, "wrong number of arguments to Sorabji::Any (#{list.elements.count} for 1)"
      # end

      FunctionAny.new(list)
    end
  end

  class FunctionAny < BasicFunction
    def to_proc
      ->(r) {
        Array(args.to_proc.call(r)).any?(&:present?)
      }
    end
  end
end
