module Sorabji
  class OperationNode < ASTNode
    def to_ast
      # Operation.new(left.to_ast, right.to_ast, operator.to_ast)
      StackOperation.new.tap do |stack|
        stack.operands.push(left.to_ast)
        op_right.elements.each do |e|
          stack.operators << e.operator.to_ast
          stack.operands << e.right.to_ast
        end
      end
    end
  end

  class StackOperation
    attr_reader :operand_stack, :operator_stack
    def initialize(options = {})
      @operand_stack = options.fetch(:operands, [])
      @operator_stack = options.fetch(:operators, [])
    end
    alias_method :operands, :operand_stack
    alias_method :operators, :operator_stack

    OPERATOR_ORDER = {
      :* => 1,
      :/ => 1
    }


    def ==(other)
      operands == other.operands && operators == other.operators
    end

    def inspect
      "<#SB_STACK #{operands.inspect}#{operators.inspect}>"
    end

    def to_proc
      sort_and_group_operations

      ->(r){ 
        current = next_operand_proc.call(r)
        puts current.inspect
        loop do # Automatically ends when StopIteration is raised by enum
          current_operator = next_operator
          current = current.to_f if current_operator == :/
          current = current.send(current_operator, next_operand_proc.call(r))
        end
        rewind!
        current
      }
    end
    
    private
      def sort_and_group_operations
        sorted = operators.sort_by(&method(:operator_order))
        return if sorted == operators # no sorting necessary
        @operand_stack, @operator_stack = *EnsureOperationPrecedence.new(operands, operators).process
      end

      def rewind!
        operators_enum.rewind
        operands_enum.rewind
      end

      def operators_enum
        @operators_enum ||= operators.to_enum
      end

      def operands_enum
        @operands_enum ||= operands.to_enum
      end

      def next_operator
        operators_enum.next.value
      end

      def next_operand_proc
        # operands.shift.to_proc
        operands_enum.next.to_proc
      end

      def operator_order(operator)
        OPERATOR_ORDER.fetch(operator.value, 2)
      end

      class EnsureOperationPrecedence
        attr_reader :operand_stack, :operator_stack, :new_operands, :new_operators
        def initialize(operand_stack, operator_stack)
          @operand_stack  = operand_stack
          @operator_stack = operator_stack
          @new_operands   = []
          @new_operators  = []
        end

        alias_method :operands, :operand_stack
        alias_method :operators, :operator_stack

        def process
          new_operands << operands.shift
          operators.each_with_index do |operator, index|
            if multiplicative?(operator.value)
              new_operands << StackOperation.new(operands: [new_operands.pop, operands.shift], operators: [operator])
            else
              new_operands << operands.shift
              new_operators << operator
            end
          end
          [new_operands, new_operators]
        end

        private

          def multiplicative?(op)
            OPERATOR_ORDER.fetch(op, 2) == 1
          end
      end
      
  end

# the ol' right associative operation!
#  class Operation < Struct.new(:left, :right, :operator)
#    # send should be safe; operators are limited by the operator grammar rule.
#    def to_proc
#      if division?
#        ->(r){ left.to_proc.call(r).to_f.send(operator.value, right.to_proc.call(r)) }
#      else
#        ->(r){ left.to_proc.call(r).send(operator.value, right.to_proc.call(r)) }
#      end
#    end
#
#    def inspect
#      "<Operation::{ #{left.inspect} #{operator.value} #{right.inspect} }>"
#    end
#
#    private
#      def division?
#        operator.value == :/
#      end
#  end
end
