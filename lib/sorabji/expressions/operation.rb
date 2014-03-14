module Sorabji
  class OperationNode < ASTNode
    def to_ast
      puts "OPERATION::"
      puts "LEFT:: #{left.inspect}"
      puts "OP/RIGHT:: #{op_right.elements.inspect}"
      # Operation.new(left.to_ast, right.to_ast, operator.to_ast)
      stack = StackOperation.new
      stack.operands.push(left.to_ast)
      
      op_right.elements.each do |e|
        stack.operators << e.operator.to_ast
        stack.operands << e.right.to_ast
      end

      puts stack.inspect
      stack
    end
  end
  
  class StackOperation
    attr_reader :operand_stack, :operator_stack
    def initialize
      @operand_stack = []
      @operator_stack = []
    end
    alias_method :operands, :operand_stack
    alias_method :operators, :operator_stack
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
end
