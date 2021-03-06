require_relative '../spec_helper'

describe Sorabji::Parser do
  specify do
    expect(parser).to be_kind_of(SorabjiParser)
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
  let(:r) { parse_to_proc(expression) }

  before do
    Sorabji.config do |c|
      c.reference_object_method = :reference_object
      c.reference_object_whitelist << :year
    end

    allow(obj).to receive(:reference_object) { reference }
  end

  [
    ["r[276]", "{276}", 5, [276]],
    ["2013 - r[276]", "2013 - {276}", 2008, [276]],
    ["year - r[276]", "{{year}} - {276}", 2008, [276]],
    ["5369", "5369", 5369, []],
    ["r[276] * r[280]", "{276} * {280}", 20, [276, 280]],
    ["r[276] / r[280]", "{276} / {280}", 1.25, [276, 280]],
    ["r[101] || r[102] || r[103]", "default{101 102 103}", 1, [101, 102, 103]],
    ["r[2103] ? r[2103] : (100 + r[2102])", "if[{2103} {2103} (100 + {2102})]", 117, [2103, 2103, 2102]],
    ['r[270] < 100 ? 1900 + r[270] : r[270]', 'if[{270} > 100 (1900 + {270}) {270}]', 2001, [270, 270, 270]],
    ['r.external_id > 1526374 ? 2 : 1', 'if[({external_id} > 1526374) "big" "small"]' , 'big', [:external_id]],
    [' (r[2465] and r[2465].include?(1)) ? 1 : 2' , 'if[included?[1 {2465}] 1 2]', 2, [2465]],
    ['[101, 102].inject(0){|s,i| s + r[i].to_i'   , 'sum[{101} {102} {103}]', 6, [101, 102, 103]],
    ['Array(r[101])', '[{101}]', [1], [101]],
    [
      '(a = [123, 456, 789].map {|x| r[x] }.compact.join("; ")).present? ? a : nil',
      'concat[present{122 123 456 789} "; "]',
      "Alamo Square; San Francisco; California",
      [122, 123, 456, 789]
    ], [
      '(a = [123, 456, 789].map {|x| r[x] }.compact.join("; ")).present? ? a : nil',
      'concat[present{122 124 457 788} "; "]',
      nil,
      [122, 124, 457, 788]
    ], ['r[1487].blank? ? nil : r[1487]', "if[all?{1487} {1487}]", nil, [1487, 1487]],
    ['r[276].blank? ? nil : r[276]', "if[all?{276} {276}]", 5, [276, 276]],
    [
      'Time.strptime("#{r[2280]} #{r[2281}", "%A, %B, %d, %Y %l:%M %p")',
      'parse_date[concat[{2280 2281} " "] "%A, %B %d, %Y %l:%M %p"]',
      Time.new(1984, 1, 10, 20, 45),
      [2280, 2281]
    ], [
      'ary = r.attributes.values_at(*%w(1381 1379 1377)).compact; ary.delete(99); (ary.inject(:+).to_f / ary.count)',
      'mean[difference{1381 1379 1377}[99]]',
      35,
      [1381, 1379, 1377]
    ], [
      'ary = r.attributes.values_at(*%w(1381 1379 1377)).compact; ary.delete(99); (ary.inject(:+).to_f / ary.count)',
      'mean[difference[present{1381 1379 1377}][99]]',
      35,
      [1381, 1379, 1377]
    ], [
      'ary = r.attributes.values_at(*%w(1381 1379 1377)).compact; ary.delete(99); (ary.inject(:+).to_f / ary.count)',
      'mean[difference[present{1384 1382 1380}][99]]',
      nil,
      [1384, 1382, 1380]
    ]

  ].each do |old_style, new_style, expectation, identifiers|
    specify(old_style) do
      ast = parse(new_style).to_ast
      expect(ast.object_identifiers).to eq identifiers
      expect(ast.to_proc.call(obj)).to eq expectation
    end
  end

  describe "extract all object idents" do
    specify "stack operation" do
      expression = "{101} + {102}"
      ast = parse(expression).to_ast
      expect(ast.object_identifiers).to eq [101, 102]
    end

    specify "functions" do
      expression = "concat[{101 102} \",\"]"
      ast = parse(expression).to_ast
      expect(ast.object_identifiers).to eq [101, 102]
    end
  end

  describe 'values other than exclusions' do
    let(:expression) { 'any?[difference{276}[1 2]]' }

    specify do
      expect(r.call({ })).to eq(false)
      expect(r.call({ 276 => [1] })).to eq(false)
      expect(r.call({ 276 => [1, 2] })).to eq(false)
      expect(r.call({ 276 => [1, 2, 3] })).to eq(true)
      expect(r.call({ 276 => [] })).to eq(false)
      expect(r.call({ 276 => [3, 4] })).to eq(true)
    end
  end

  describe 'complex inclusion, exclusion' do
    let(:expression) do
      'if[any?[difference{101}[1]] 2 if[list_equal?{101}[1] 1]]'
    end

    specify do
      expect(r.call({ })).to eq(nil)
      expect(r.call({ 101 => [1] })).to eq(1)
      expect(r.call({ 101 => [1, 2] })).to eq(2)
      expect(r.call({ 101 => [2, 3] })).to eq(2)
      expect(r.call({ 101 => [] })).to eq(nil)
    end
  end

  describe 'any with intersect' do
    let(:expression) do
      'if[any?[intersect{101}[1 2 3]] 1 0]'
    end

    specify do
      expect(r.call({ })).to eq(0)
      expect(r.call({ 101 => [1] })).to eq(1)
      expect(r.call({ 101 => [1, 2] })).to eq(1)
      expect(r.call({ 101 => [2, 3, 4, 5, 6] })).to eq(1)
      expect(r.call({ 101 => [4, 5, 6] })).to eq(0)
    end
  end
end
