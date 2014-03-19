module Sorabji
  class ListFunctionNode < ASTNode
    def to_ast
      ListFunction.new(left.to_ast, right.to_ast, operation.text_value)
    end
  end
  
  class ListFunction < Struct.new(:left, :right, :operation)
    def to_proc
      sym = symbol_for(operation)
      ->(r){ Array(left.to_proc.call(r)).flatten.send(sym, Array(right.to_proc.call(r)).flatten) }
    end

    private

    def symbol_for(op)
      {
        'union' => :|,
        'difference' => :-,
        'join' => :+,
        'intersect' => :&
      }.fetch(op)
    end

  end
end
