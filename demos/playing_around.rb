require_relative '../lib/suggestor'

engine = Suggestor::Engine.new

# I'm using test data of Users and their movie recommendations
# Each user (identified by their ids) have a hash of their movies ids and
# what they've rate them with
json = File.read("test/test.json")

engine.load_data(json)

# Let's get some similar users 
puts engine.similar_items_to("2").inspect

# So, after knowing them, why not having some recommendations? 
puts engine.recommented_related_items_for("2", algorithm: :euclidean_distance)