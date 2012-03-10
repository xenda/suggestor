# Suggestor 
## Recommendations gem

Suggestor is a gem that will help you relating data. For example, given a User, Movie and Review class, 
being the Review related to the User and and Movie and having a rating attribute, the gem would use those 
information to correlate the information, and give results, like related Movies, Similar Users (based on their
tastes) and alike. 

## Usage

The gem needs an structure of date like this:
 
    data = '{"Alvaro Pereyra Rabanal": {"Primer": 10, "Memento": 9}, "Gustavo Leon": {"The Matrix":8, "Harry Potter": 8}}'

Each element will correspond to, following the example, users. They will gave access to related items (reviews for movies). 

In the example, the user "Alvaro Pereyra Rabanal" has seen movies "Primer" and "Memento", given them a rating of 10 and 9, respectively. Similar with user with "Gustavo Leon".

After loading the gem with the data: 
    
    suggestor = Suggestor::Suggestor.new(data)

We can start to get some results. 


### Similar items

For example, we can get similar users: 

    suggestor.similar_to("Alvaro Pereyra Rabanal")

Which will return an structure like

    [["label", similarity_score], ["label": similarity_score]]

Like:

    [["Eogen Clase", 0.0001649620587264929], ["Daniel Subauste", 0.00011641443538998836], ["4D2Studio Diseno y Animacion", 8.548469823901521e-05], ["Rafael  Lanfranco", 6.177033788374823e-05], ["Veronica Zapata Gotelli", 6.074965068950854e-05]]

Thus, you can load the data and save their similarity scores for later use.

You can limit the data passing a "size" argument:

  suggestor.similar_to("Alvaro Pereyra Rabanal", :size => 5)

Now, that fine and all, but what about Mr. Bob who always is ranking everything
higher. ID4 maybe is not that good after all. If that happens, Suggestor allows you to change the algorithm used:

    algorithm = Suggestor::Algorithms::PearsonCorrelation
    suggestor = Suggestor::Suggestor.new(data, algorithm)

    suggestor.recommended_to("Alvaro Pereyra Rabanal")

There are two implemented methods, Euclidean Distance and Pearson Correlation.

Use Euclidean Distance (default) to compare items and get suggestions base on
actions that are normalized or not subjective (like user points earned by actions on a web site).

Use Pearson Correlation is there's some bias on the data. The algorithm will
take in mind if some user grades higher or lower and return more exact suggestions than Euclidean on that area.

### Suggested items

Most interestingly, the gem allows you to get suggestions base on the data.
For example, which movies shoud user "2" watch based on his reviews, and similar other users tastes?

    suggestor.recommended_to("Alvaro Pereyra Rabanal")

As before, the structure returned will be

    [["label", similarity_score], ["label": similarity_score]]

But in this case, it will represent movie labels, and how similar they are. You
can easily use this data to save it to a BD, since Movie ratings tend to estabilize on time and won't change that often. 

### Similar related items

We can also invert the data that the user has added, enableing us to get 
similar related items. For example, let's say I'm on a Movie profile and
want to check which other movies are similar to it:

    suggestor.similar_related_to("Batman Begins ", :size => 5)

### Suggested items for a set

Say that you have the list of the movies that you liked the most and you'd like to know what you should watch next. Suggestor has you covered:

	suggestor.items_for_set ['Batman Begins', 'Cyrus']
	# => [["Kung Fu Hustle", 0.5], ["Super 8 ", 0.5], ["Celda 211 ", 0.5], ... ]

Suggestor of course considers the whole set when recommending new items, so different sets will yield different results, even if they differ in only one item. Say you picked Super 8 from the previous query:
	suggestor.items_for_set ['Batman Begins', 'Cyrus', 'Super 8 ']
	# => [["Rapidos y Furiosos 5", 0.3333333333333333], ["Agente Salt", 0.3333333333333333], ["Mary and Max ", 0.3333333333333333], ... ]

But if you had picked Kung Fu Hustle:
	suggestor.items_for_set ['Batman Begins', 'Cyrus', 'Kung Fu Hustle']
	# => [["El mensajero ", 0.6666666666666666], ["El Club de la Pelea", 0.3333333333333333], ["Un tonto en el amor", 0.3333333333333333], ... ]

Now you can go and build your awesome recommendations web site :)
