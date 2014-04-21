require 'active_support/core_ext'
module Sorabji
  # returns a string from an argument list. The last item in the list will be used as the 
  # separator.
  #
  # Returns nil if the elements array is empty.

  class FunctionConcatNode < FunctionNode
    def to_ast
      FunctionConcat.new(args.to_ast)
    end
  end

  class FunctionConcat < Struct.new(:args)
    def to_proc
      ->(r){ 
        *elements, sep = args.to_proc.call(r).flatten
        elements.compact.join(sep.to_s) if elements.any?(&:present?)
      }
    end
  end
end
