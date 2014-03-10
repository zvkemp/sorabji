require_relative '../spec_helper'

describe Sorabji::Parser do
  # let(:parser){ Sorabji::Parser }
  let(:parser){ SorabjiParser.new }
  specify { parser.wont_be_nil }
  specify { parser.must_be_instance_of SorabjiParser }

  describe 'errors' do
  end


  describe 'simple expressions' do
    let(:integer){ '123' }
    let(:respondent_variable){ "{123}" }
    let(:respondent_symbol){ "{external_id}" }
    let(:survey_variable){ "{{123}}" }

    specify "parsing an integer" do
      parse_tree = parser.parse(integer)
      parse_tree.to_ast.must_equal Sorabji::IntegerLiteral.new(123)
    end
  end
end
