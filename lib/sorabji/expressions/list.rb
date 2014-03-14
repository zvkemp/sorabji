module Sorabji
  class ListNode < ASTNode
    def to_ast
      List.new(values.elements.map do |e|
        e.elements.map(&:to_ast)
      end.flatten.compact)
    end
  end

  class List < Struct.new(:elements)
    def to_proc
      -> (r) { elements.map {|e| e.to_proc.call(r) } }
    end
  end
end

