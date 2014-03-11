require 'minitest/autorun'
require 'minitest/pride'

require 'sorabji'


class MiniTest::Spec
  def parser
    SorabjiParser.new
  end

  def parse(str)
    parser.parse(str)
  end
end
