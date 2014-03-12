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

  class FunctionTernaryNode < FunctionNode
    def to_ast
      list = args.to_ast
      unless list.elements.count == 3
        raise ArgumentError, "wrong number of arguments to Sorabji::Ternary(if[]) (#{list.elements.count} for 3)"
      end

      FunctionTernary.new(list)
    end
  end

  class FunctionTernary < Struct.new(:args)
    def to_proc
      ->(r) {
        # condition, v_true, v_false = *args.to_proc.call(r)
        # condition ? v_true : v_false
        # Need to defer the proc call on v_true
        condition, v_true, v_false = *args.elements
        (condition.to_proc.call(r) ? v_true : v_false).to_proc.call(r)
      }
    end
  end
end
