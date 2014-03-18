require_relative '../spec_helper'

describe Sorabji::Parser do
  specify { parser.wont_be_nil }
  specify { parser.must_be_instance_of SorabjiParser }

  describe 'errors' do
  end
end

describe 'dashboard examples' do
  let(:obj){{
    276 => 5,
    280 => 4,
    103 => 2,
    2102 => 17,
    270 => 101,
    external_id: 1526375,
    101 => 1,
    102 => 3,
    123 => "Alamo Square",
    456 => "San Francisco",
    789 => "California",
    2280 => "Tuesday, January 10, 1984",
    2281 => "8:45 PM",
    1381 => 35,
    1377 => 99

  }}

  let(:reference){ OpenStruct.new(year: 2013) }

  before { stub(obj).reference_object { reference } }

  [
    ["r[276]"                                     , "{276}"                                       , 5],
    ["2013 - r[276]"                              , "2013 - {276}"                                , 2008],
    ["year - r[276]"                              , "{{year}} - {276}"                            , 2008],
    ["5369"                                       , "5369"                                        , 5369],
    ["r[276] * r[280]"                            , "{276} * {280}"                               , 20],
    ["r[276] / r[280]"                            , "{276} / {280}"                               , 1.25],
    ["r[101] || r[102] || r[103]"                 , "default{101 102 103}"                  , 1],
    ["r[2103] ? r[2103] : (100 + r[2102])"        , "if[{2103} {2103} (100 + {2102})]"            , 117],
    ['r[270] < 100 ? 1900 + r[270] : r[270]'      , 'if[({270} > 100) (1900 + {270}) {270}]'      , 2001],
    ['r.external_id > 1526374 ? 2 : 1'            , 'if[({external_id} > 1526374) "big" "small"]' , 'big'],
    [' (r[2465] and r[2465].include?(1)) ? 1 : 2' , 'if[included?[1 {2465}] 1 2]'                 , 2],
    ['[101, 102].inject(0){|s,i| s + r[i].to_i'   , 'sum[{101} {102} {103}]'                      , 6],
    ['Array(r[101])'                              , '[{101}]'                                     , [1]],
    [
      '(a = [123, 456, 789].map {|x| r[x] }.compact.join("; ")).present? ? a : nil',
      'concat[present{122 123 456 789} "; "]', 
      "Alamo Square; San Francisco; California"
    ], [
      '(a = [123, 456, 789].map {|x| r[x] }.compact.join("; ")).present? ? a : nil',
      'concat[present{122 124 457 788} "; "]', 
      nil
    ], ['r[1487].blank? ? nil : r[1487]', "if[all?{1487} {1487}]", nil],
    ['r[276].blank? ? nil : r[276]', "if[all?{276} {276}]", 5],
    [
      'Time.strptime("#{r[2280]} #{r[2281}", "%A, %B, %d, %Y %l:%M %p")',
      'parse_date[concat[{2280 2281} " "] "%A, %B %d, %Y %l:%M %p"]', 
      Time.new(1984, 1, 10, 20, 45)
    ], [
      'ary = r.attributes.values_at(*%w(1381 1379 1377)).compact; ary.delete(99); (ary.inject(:+).to_f / ary.count)',
      'mean[present[difference{1381 1379 1377}[99]]]',
      35
    ], [
      'ary = r.attributes.values_at(*%w(1381 1379 1377)).compact; ary.delete(99); (ary.inject(:+).to_f / ary.count)',
      'mean[difference[present{1381 1379 1377}][99]]',
      35
    ], [
      'ary = r.attributes.values_at(*%w(1381 1379 1377)).compact; ary.delete(99); (ary.inject(:+).to_f / ary.count)',
      'mean[difference[present{1384 1382 1380}][99]]',
      nil
    ]

  ].each do |old_style, new_style, expectation|
    specify(old_style) do
      ast = parse(new_style).to_ast
      ast.to_proc.call(obj).must_equal expectation
    end
  end
end
