require_relative '../lib/suggestor'

# I'm using test data of Users and their movie recommendations
# Each user have a hash of their reviews with the movie and
# what they've rate them with
json = File.read("test/movies.json")
engine = Suggestor::Engine.new(json, Suggestor::Algorithms::EuclideanDistance)

# Let's get some similar users 
name = "Alvaro Pereyra Rabanal"
puts "Who is similar to #{name}"
puts engine.similar_to(name, size: 5).inspect

puts
puts

# So, after knowing them, why not having some recommendations? 
puts "Interesting! But I want to see some stuff at the movies, what to watch?"
opts = {size: 5}
results = engine.recommended_to("Alvaro Pereyra Rabanal", opts)

puts results.inspect

puts
puts

# That's good, but let's take in mind bias while using Pearson Correlation:
puts "Adjust this results please"
engine = Suggestor::Engine.new(json,Suggestor::Algorithms::PearsonCorrelation)

ops = {size: 5}
results = engine.recommended_to("Alvaro Pereyra Rabanal", opts)
puts results.inspect

puts
puts

name = "Batman Begins "
puts "Now that was nice. But which others are similar to '#{name}'"
ops = {size: 10}
results = engine.similar_related_to(name, opts)
puts results.inspect
