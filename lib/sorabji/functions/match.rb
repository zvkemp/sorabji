module Sorabji
  class FunctionMatchNode < FunctionNode
    def to_ast
      FunctionMatch.new(args.to_ast)
    end
  end


  class FunctionMatch < BasicFunction
    def to_proc
      ->(r){
        sample, *rest = args.to_proc.call(r).flatten.map {|x| "#{x}" } 
        rest.any? {|x| x[sample] }
      }
    end
  end
end

