# require 'JSON'
require_relative 'datum'

module Suggestor

  class WrongInputFormat < Exception; end

  class Engine

    attr_accessor :data

    def parse(input)
      @data = parse_from_json(input)
    rescue Exception => ex
      raise WrongInputFormat, "Wrong Data format: #{ex.message}" 
    end

    private

    def parse_from_json(json)
      Datum.new(JSON.parse(json))
    end

  end

end