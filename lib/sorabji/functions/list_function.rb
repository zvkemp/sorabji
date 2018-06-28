require 'set'
module Sorabji
  class ListFunctionNode < ASTNode
    def to_ast
      ListFunction.new(left.to_ast, right.to_ast, operation.text_value)
    end
  end

  class ListFunction < Struct.new(:left, :right, :operation)
    LIST_EQUAL = 'list_equal?'.freeze
    def to_proc
      return to_list_equal_proc if operation == LIST_EQUAL
      sym = symbol_for(operation)
      ->(r){ Array(left.to_proc.call(r)).flatten.send(sym, Array(right.to_proc.call(r)).flatten) }
    end

    def object_identifiers
      [left, right].map(&:object_identifiers).flatten
    end

    private

    def to_list_equal_proc
      -> (r) {
        Array(left.to_proc.call(r)).flatten.to_set ==
          Array(right.to_proc.call(r)).flatten.to_set
      }
    end

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
