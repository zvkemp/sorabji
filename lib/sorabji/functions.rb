module Sorabji
  class FunctionNode < ASTNode
  end

  class FunctionDefaultNode < FunctionNode
    def to_ast
      FunctionDefault.new(args.to_ast)
    end
  end

  class BasicFunction < Struct.new(:args)
    def object_identifiers
      args.object_identifiers.flatten
    end
  end

  class FunctionDefault < BasicFunction
    def to_proc
      ->(r) { args.to_proc.call(r).detect {|x| x } }
    end
  end

  require 'sorabji/functions/ternary'
  require 'sorabji/functions/mean'
  require 'sorabji/functions/included'
  require 'sorabji/functions/match'
  require 'sorabji/functions/sum'
  require 'sorabji/functions/all'
  require 'sorabji/functions/concat'
  require 'sorabji/functions/present'
  require 'sorabji/functions/parse_date'
  require 'sorabji/functions/list_function'
end
