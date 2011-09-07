# Suggestor 
## Recommendations gem

Suggestor is a gem that will help you relating data. For example, given a User, Movie and Review class, 
being the Review related to the User and and Movie and having a rating attribute, the gem would use those 
information to correlate the information, and give results, like related Movies, Similar Users (based on their
tastes) and alike. 

The gem would load up an structure of date like  
 
   {:user => 1, :ratings =>[{:ratings => 12, :movie => 1}, {:ratings => 1, :movie => 12}]

And use it to apply some algorithms to it (taking in mind bias, relations, etc).
