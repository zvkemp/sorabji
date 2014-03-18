require 'active_support/core_ext/object/blank'

module Sorabji
  class FunctionAllNode < FunctionNode
    def to_ast
      FunctionAll.new(args.to_ast)
    end
  end

  class FunctionAll < Struct.new(:args)
    def to_proc
      ->(r){ Array(args.to_proc.call(r)).all?(&:present?) }
    end
  end
end

