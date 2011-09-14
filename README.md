# Suggestor 
## Recommendations gem

Suggestor is a gem that will help you relating data. For example, given a User, Movie and Review class, 
being the Review related to the User and and Movie and having a rating attribute, the gem would use those 
information to correlate the information, and give results, like related Movies, Similar Users (based on their
tastes) and alike. 

## Usage

The gem needs an structure of date like this:
 
    data = {"1": {"10": 10, "12": 1}, "2": {"11":5, "12": 4}}

Each element will ("1" or "2") correspond to, following the example, to user ids. They will gave access to related items (movies). 

In the example, the user "1" has seen movies identified with ids "10" and "12", given them a rating of 10 and 1, respectively. Similar with user with id "2".

After loading the gem with the data: 
    
    engine = Suggestor::Engine.new
    engine.load_data(data)

We can start to get some results. 


### Similar items

For example, we can get similar users: 

    engine.similar_items_to("1")

Which will return an structure like

    {id: similarity_score, id2: similarity_score }

Thus, you can load the data and save their similarity scores for later use.

Now, that fine and all, but what about Mr. Bob who always is ranking everything
higher. ID4 maybe is not that good after all. If that happens, Suggestor allows you to change the algorithm used:

    engine.similar_items_to("1", :algorithm => :pearson_correlation)

There are two implemented methods, Euclidean Distance and Pearson Correlation.

Use Euclidean Distance (default) to compare items and get suggestions base on
actions that are normalized or not subjective (like user points earned by actions on a web site).

Use Pearson Correlation is there's some bias on the data. The algorithm will
take in mind if some user grades higher or lower and return more exact suggestions than Euclidean on that area.

### Suggested items

Most interestingly, the gem allows you to get suggestions base on the data.
For example, which movies shoud user "2" watch based on his reviews, and similar other users tastes?

    engine.recommented_related_items_for("2",:pearson_correlation)

As before, the structure returned will be

    {id: similarity_score, id2: similarity_score }

But in this case, it will represent movie id's, and how similar are. You
can easily use this data to save it to a BD, since Movie ratings tend to estabilize on time and won't change that often. 