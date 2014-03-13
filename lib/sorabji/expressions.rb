module Sorabji
  class BracketedNode < ASTNode
    def to_ast
      Bracketed.new(content.to_ast)
    end
  end

  class Bracketed < Struct.new(:contents)
    def to_proc
      contents.to_proc
    end
  end

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

  class OperationNode < ASTNode
    def to_ast
      Operation.new(left.to_ast, right.to_ast, operator.to_ast)
    end
  end

  class Operation < Struct.new(:left, :right, :operator)
    # send should be safe; operators are limited by the operator grammar rule.
    def to_proc
      if division?
        ->(r){ left.to_proc.call(r).to_f.send(operator.value, right.to_proc.call(r)) }
      else
        ->(r){ left.to_proc.call(r).send(operator.value, right.to_proc.call(r)) }
      end
    end

    def inspect
      "<Operation::{ #{left.inspect} #{operator.value} #{right.inspect} }>"
    end

    private
      def division?
        operator.value == :/
      end
  end

  class ObjectIdentifierNode < ASTNode
    def to_ast
      identifiers = ident.elements.map {|x| ObjectIdentifier.new(x.ident_e.to_ast.value) }
      if identifiers.size == 1
        identifiers.first
      else
        List.new(identifiers)
      end
    end
  end

  class ObjectIdentifier < Struct.new(:value)
    def to_proc
      ->(r){ r[value] }
    end

    def inspect
      "{#{value}}"
    end
  end

  class ReferenceObjectIdentifierNode < ASTNode
    def to_ast
      ReferenceObjectIdentifier.new(ident.to_ast.value)
    end
  end

  class ReferenceObjectIdentifier < Struct.new(:value)
    def to_proc
      ->(r){ r.reference_object.send(value) }
    end
  end

end
