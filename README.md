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
    
    engine = Suggestor::Engine.new
    engine.load_data(data)

We can start to get some results. 


### Similar items

For example, we can get similar users: 

    engine.similar_items_to("Alvaro Pereyra Rabanal")

Which will return an structure like

    [["label", similarity_score], ["label": similarity_score]]

Like:

    [["Eogen Clase", 0.0001649620587264929], ["Daniel Subauste", 0.00011641443538998836], ["4D2Studio Diseno y Animacion", 8.548469823901521e-05], ["Rafael  Lanfranco", 6.177033788374823e-05], ["Veronica Zapata Gotelli", 6.074965068950854e-05]]

Thus, you can load the data and save their similarity scores for later use.

You can limit the data passing a "size" argument:

  engine.similar_items_to("Alvaro Pereyra Rabanal", :size => 5)

Now, that fine and all, but what about Mr. Bob who always is ranking everything
higher. ID4 maybe is not that good after all. If that happens, Suggestor allows you to change the algorithm used:

    opts = { algorithm: :pearson_correlation }
    engine.recommended_related_items_for("Alvaro Pereyra Rabanal", opts)

There are two implemented methods, Euclidean Distance and Pearson Correlation.

Use Euclidean Distance (default) to compare items and get suggestions base on
actions that are normalized or not subjective (like user points earned by actions on a web site).

Use Pearson Correlation is there's some bias on the data. The algorithm will
take in mind if some user grades higher or lower and return more exact suggestions than Euclidean on that area.

### Suggested items

Most interestingly, the gem allows you to get suggestions base on the data.
For example, which movies shoud user "2" watch based on his reviews, and similar other users tastes?

    opts = { algorithm: :pearson_correlation }
    engine.recommended_related_items_for("Alvaro Pereyra Rabanal", opts)

As before, the structure returned will be

    [["label", similarity_score], ["label": similarity_score]]

But in this case, it will represent movie labels, and how similar they are. You
can easily use this data to save it to a BD, since Movie ratings tend to estabilize on time and won't change that often. 

### Similar related items

We can also invert the data that the user has added, enableing us to get 
similar related items. For example, let's say I'm on a Movie profile and
want to check which other movies are similar to it:

    engine.similar_related_items_to("Batman Begins ", :size => 5)

Now you can go and build your awesome recommendations web site :)
