require 'treetop'


module Sorabji
  class Parser
    base_path = File.expand_path(File.dirname(__FILE__))
    Treetop.load(File.join(base_path, 'sorabji.treetop'))

    class << self
      def parse(data)
        tree = parser.parse(data)

        if tree.nil?
          raise Sorabji::SyntaxError, "Parse error at offset: #{parser.index}"
        end
      end

      private

        def parser
          puts "parser..."
          Sorabji.recompile!
          SorabjiParser.new
        end

    end
  end


  def Sorabji.parse(*args)
    Parser.parse(*args)
  end
  
  def self.recompile!
    base_path = File.expand_path(File.dirname(__FILE__))
    Treetop.load(File.join(base_path, 'sorabji.treetop'))
  end

  class SyntaxError < ::SyntaxError
    def to_s
      "<Sorabji::SyntaxError>:: #{message}"
    end
  end
end
