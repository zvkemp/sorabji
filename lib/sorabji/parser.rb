require 'treetop'


module Sorabji
  class Parser
    base_path = File.expand_path(File.dirname(__FILE__))
    Treetop.load(File.join(base_path, 'sorabji.treetop'))
    @@parser = SorabjiParser.new


    class << self
      def parse(data)
        tree = parser.parse(data)

        if tree.nil?
          raise Sorabji::SyntaxError, "Parse error at offset: #{parser.index}"
        end
      end

      private

        def parser
          @@parser
        end
    end
  end

  class SyntaxError < ::SyntaxError
  end
end
