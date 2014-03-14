require 'minitest/autorun'
require 'minitest/pride'

require 'sorabji'
require 'ostruct'
require 'rr'


class MiniTest::Spec
  def parser
    SorabjiParser.new
  end

  def parse(str)
    parser.parse(str)
  end
end
