require 'sorabji'
require 'ostruct'

class Object
  RSPEC_ADAPTER = Object.new.tap {|x| x.extend(RSpec::Matchers) }

  def must_equal(*args)
    __r.expect(self).to __r.eq(*args)
  end

  def wont_equal(*args)
    __r.expect(self).not_to __r.eq(*args)
  end

  def must_be_nil
    __r.expect(self).to __r.be_nil
  end

  def wont_be_empty
    __r.expect(self).not_to __r.be_empty
  end

  def must_be_empty
    __r.expect(self).to __r.be_empty
  end

  def wont_be(sym)
    __r.expect(self.send(sym)).not_to __r.be_truthy
  end

  def must_be(sym)
    __r.expect(self.send(sym)).to __r.be_truthy
  end

  def must_be_kind_of(obj)
    __r.expect(self).to __r.be_kind_of(obj)
  end

  def must_include(*args)
    __r.expect(self).to __r.include(*args)
  end

  def wont_include(*args)
    __r.expect(self).not_to __r.include(*args)
  end

  def must_be_success
    __r.expect(self).to __r.be_success
  end

  def wont_be_nil
    __r.expect(self).not_to __r.be_nil
  end

  def must_raise(e)
    __r.expect(self).to __r.raise_error(e)
  end

  def must_be_silent
    __r.expect(self).not_to __r.raise_error
  end

  def must_respond_to(sym)
    __r.expect(self).to __r.respond_to(sym)
  end

  def wont_respond_to(sym)
    __r.expect(self).not_to __r.respond_to(sym)
  end

  def must_be_instance_of(obj)
    __r.expect(self).to __r.be_instance_of(obj)
  end

  private

  def __r
    RSPEC_ADAPTER
  end
end

module SpecHelpers
  def parser
    SorabjiParser.new
  end

  def parse(str)
    parser.parse(str)
  end
end

RSpec.configure do |config|
  config.include(SpecHelpers)
  config.before { Sorabji::reset_config! }
end
