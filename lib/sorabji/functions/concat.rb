module Sorabji
  # returns a string from an argument list. The last item in the list will be used as the 
  # separator.
  #

  class FunctionConcatNode < FunctionNode
    def to_ast
      FunctionConcat.new(args.to_ast)
    end
  end

  class FunctionConcat < Struct.new(:args)
    def to_proc
      ->(r){ 
        *elements, sep = args.to_proc.call(r).flatten
        elements.join(sep.to_s)
      }
    end
  end
end
