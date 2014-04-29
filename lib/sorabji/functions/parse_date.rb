require 'date'
module Sorabji
  class FunctionParseDateNode < FunctionNode
    def to_ast
      FunctionParseDate.new(args.to_ast)
    end
  end

  class FunctionParseDate < BasicFunction
    def to_proc
      ->(r) {
        value, format_string = args.to_proc.call(r)
        Time.strptime(value, format_string)
      }
    end
  end
end

