require_relative '../spec_helper'

describe 'Sorabji::VERSION' do
  specify { expect(Sorabji::VERSION).not_to be_nil }
end
