require "sorabji/version"

module Sorabji
  require 'sorabji/primitives'
  require 'sorabji/expressions'
  require 'sorabji/functions'
  require 'sorabji/parser'

  class << self
    def config
      @configuration ||= default_configuration
      yield @configuration if block_given?
      @configuration
    end

    private

    def default_configuration
      Configuration.new(:default_reference_method)
    end
  end


  class Configuration < Struct.new(:reference_object_method)
  end
end

