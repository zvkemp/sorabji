require_relative '../spec_helper'

describe 'Sorabji::VERSION' do
  specify { Sorabji::VERSION.wont_be_nil }
end
