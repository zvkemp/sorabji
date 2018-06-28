module Sorabji
  class FunctionEmptyNode < FunctionNode
    def to_ast
      FunctionEmpty.new(args.to_ast)
    end
  end

  class FunctionEmpty < BasicFunction
    def to_proc
      ->(r) {
        Array(args.to_proc.call(r)).all?(&:blank?)
      }
    end
  end
end
