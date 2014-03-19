require 'minitest/autorun'
require 'minitest/pride'

require 'sorabji'
require 'ostruct'
require 'rr'


class MiniTest::Spec
  before do
    Sorabji::reset_config!
  end

  def parser
    SorabjiParser.new
  end

  def parse(str)
    parser.parse(str)
  end
end
