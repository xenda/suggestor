require_relative 'lib/suggestor'

engine = Suggestor::Engine.new
json = File.read("test/test.json")
engine.load(json)
puts engine.collection.inspect