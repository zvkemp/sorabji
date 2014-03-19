module Sorabji
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
end

