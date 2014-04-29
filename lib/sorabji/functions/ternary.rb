module Sorabji
  class FunctionTernaryNode < FunctionNode
    def to_ast
      list = args.to_ast
      unless list.elements.count == 3 || list.elements.count == 2
        raise ArgumentError, "wrong number of arguments to Sorabji::Ternary(if[]) (#{list.elements.count} for 3)"
      end

      FunctionTernary.new(list)
    end
  end

  class FunctionTernary < BasicFunction
    def to_proc
      ->(r) {
        # condition, v_true, v_false = *args.to_proc.call(r)
        # condition ? v_true : v_false
        # Need to defer the proc call on v_true
        condition, v_true, v_false = *args.elements
        v_false ||= NullValue.new
        (condition.to_proc.call(r) ? v_true : v_false).to_proc.call(r)
      }
    end
  end

  class NullValue
    def initialize(*)
    end

    def to_proc
      ->(*){ nil }
    end
  end
end
