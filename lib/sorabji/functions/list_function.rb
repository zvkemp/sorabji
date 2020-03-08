require 'set'
module Sorabji
  class ListFunctionNode < ASTNode
    def to_ast
      ListFunction.new(left.to_ast, right.to_ast, operation.text_value)
    end
  end

  class ListFunction < Struct.new(:left, :right, :operation)
    LIST_EQUAL = 'list_equal?'.freeze
    HAS_ALL = 'has_all?'.freeze
    HAS_ANY = 'has_any?'.freeze

    def to_proc
      return to_list_equal_proc if operation == LIST_EQUAL
      return to_list_equal_proc if operation == HAS_ALL
      return to_list_has_any_proc if operation == HAS_ANY

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

    def to_list_has_any_proc
      -> (r) {
        (Array(left.to_proc.call(r)).flatten.to_set &
          Array(right.to_proc.call(r)).flatten.to_set).any?(&:present?)
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
