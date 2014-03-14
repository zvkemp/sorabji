module Sorabji
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
end

