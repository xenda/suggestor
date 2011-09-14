require 'delegate'

module Suggestor

  class Datum < DelegateClass(Hash)

    def initialize(hash)
      super(hash)
    end

  end

end