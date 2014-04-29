module Sorabji
  class FunctionSumNode < FunctionNode
    def to_ast
      FunctionSum.new(args.to_ast)
    end
  end

  class FunctionSum < BasicFunction
    def to_proc
      ->(r){ Array(args.to_proc.call(r)).compact.inject(0, :+) }
    end
  end
end
