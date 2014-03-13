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

  class FunctionMeanNode < FunctionNode
    def to_ast
      FunctionMean.new(args.to_ast)
    end
  end

  class FunctionMean < Struct.new(:args)
    def to_proc
      ->(r){ 
        values = args.to_proc.call(r).compact
        values.inject(:+).to_f / values.count
      }
    end
  end


  class FunctionIncludedNode < FunctionNode
    def to_ast
      list = args.to_ast
      unless list.elements.count == 2
        raise ArgumentError, "wrong number of arguments to Sorabji::Included (#{list.elements.count} for 2)"
      end

      FunctionIncluded.new(list)
    end
  end

  class FunctionIncluded < Struct.new(:args)
    def to_proc
      ->(r){
        exp, value = *args.elements
        Array(value.to_proc.call(r)).include?(exp.to_proc.call(r))
      }
    end
  end

  class FunctionSumNode < FunctionNode
    def to_ast
      FunctionSum.new(args.to_ast)
    end
  end

  class FunctionSum < Struct.new(:args)
    def to_proc
      ->(r){ Array(args.to_proc.call(r)).compact.inject(0, :+) }
    end
  end
end
