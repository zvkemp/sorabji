module Sorabji
  class BooleanNode < ASTNode
  end

  class BooleanTrueNode < BooleanNode
    def to_ast
      Boolean.new(true)
    end
  end

  class BooleanFalseNode < BooleanNode
    def to_ast
      Boolean.new(false)
    end
  end

  class Boolean < Struct.new(:value)
    def to_proc
      ->(*){ value }
    end
  end
end
