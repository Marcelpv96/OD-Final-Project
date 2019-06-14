// create applications
LOAD CSV WITH HEADERS FROM 'file:///app_reduced.csv' AS app
MERGE (application:App {name : app.app, price : app.price, rating : app.rating})

// create categories
LOAD CSV WITH HEADERS FROM 'file:///categories.csv' AS categories
MERGE (:Category {name:categories.category})

// link apps and categories
LOAD CSV WITH HEADERS FROM 'file:///categories.csv' AS categories
MATCH (app:App {name : categories.app}), (cat:Category {name : categories.category})
MERGE (app)-[:hasCategory]->(cat)

// create relationships between apps
LOAD CSV WITH HEADERS FROM 'file:///related.csv' AS relations
MATCH (app:App {name : relations.app}), (related:App {name : relations.related})
MERGE (app)-[:related{kind : relations.kind}]->(related)

// create reviews and reviewers
LOAD CSV WITH HEADERS FROM 'file:///reviews.csv' AS reviews
MERGE (review:Review {id : reviews.reviewID, overall : reviews.overall, review : reviews.review})
MERGE (reviewer:Reviewer {id : reviews.reviewerID, name : reviews.reviewerName})
MERGE (reviewer)-[:writeReview]->(review)

// link reviews and apps
LOAD CSV WITH HEADERS FROM 'file:///reviews.csv' AS reviews
MATCH (app:App {name : reviews.app}), (review:Review {id : reviews.reviewID})
MERGE (app)<-[:review]-(review)
