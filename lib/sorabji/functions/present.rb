module Sorabji
  # returns a string from an argument list. The last item in the list will be used as the 
  # separator.
  #
  # 

  class FunctionPresentNode < FunctionNode
    def to_ast
      FunctionPresent.new(args.to_ast)
    end
  end

  class FunctionPresent < Struct.new(:args)
    def to_proc
      ->(r){ Array(args.to_proc.call(r)).flatten.select(&:present?) }
    end
  end
end
