require 'active_support/core_ext/object'

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

  class FunctionConcat < BasicFunction
    def to_proc
      ->(r){
        *elements, sep = args.to_proc.call(r).flatten
        elements.compact.join(sep.to_s) if elements.any?(&:present?)
      }
    end
  end
end
