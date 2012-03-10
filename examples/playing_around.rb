require_relative '../lib/suggestor'

# I'm using test data of Users and their movie recommendations
# Each user have a hash of their reviews with the movie and
# what they've rate them with
json = File.read("test/movies.json")
suggestor = Suggestor::Suggestor.new(json)

# Let's get some similar users 
name = "Alvaro Pereyra Rabanal"
puts "Who is similar to #{name}"
puts suggestor.similar_to(name, size: 5).inspect

puts
puts

# So, after knowing them, why not having some recommendations? 
puts "Interesting! But I want to see some stuff at the movies, what to watch?"
opts = {size: 5}
results = suggestor.recommended_to("Alvaro Pereyra Rabanal", opts)

puts results.inspect

puts
puts

# That's good, but let's take in mind bias while using Pearson Correlation:
puts "Adjust this results please"
suggestor = Suggestor::Suggestor.new(json,Suggestor::Algorithms::PearsonCorrelation)

ops = {size: 5}
results = suggestor.recommended_to("Alvaro Pereyra Rabanal", opts)
puts results.inspect

puts
puts

puts "Adjust this results please"
suggestor = Suggestor::Suggestor.new(json)

name = "Batman Begins "
puts "Now that was nice. But which others are similar to '#{name}'"
ops = {size: 10}
results = suggestor.similar_related_to(name, opts)
puts results.inspect

puts
puts

set = ['Batman Begins', 'Cyrus']
puts "Great! One more thing: if I've watched all these movies: #{set.inspect},
which should I watch next?"
results = suggestor.items_for_set set
puts results.inspect
