module Sorabji
  class FunctionNode < ASTNode
  end

  class FunctionDefaultNode < FunctionNode
    def to_ast
      FunctionDefault.new(args.to_ast)
    end
  end

  class FunctionDefault < Struct.new(:args)
    def to_proc
      ->(r) { args.to_proc.call(r).detect {|x| x } }
    end
  end
end
