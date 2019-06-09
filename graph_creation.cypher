/* Create app with the information provided by app.csv */
LOAD CSV WITH HEADERS FROM 'file:///app.csv' AS app

MERGE (app:App {name:app.name, price:app.price, dni:app.aggregateRating})


WITH count(*) as dummy


/* Create categories and relations with the information provided by categories.csv */
LOAD CSV WITH HEADERS FROM 'file:///categories.csv' AS categories

MERGE (category:Category {name:categories.category})
MATCH (app:App)
WHERE app.name == categories.app
MERGE (app)-[:hasCategory]->(category)


WITH count(*) as dummy


/* Create relations with the information provided by categories.csv */
LOAD CSV WITH HEADERS FROM 'file:///related.csv' AS relations
MATCH (app:App), (related:App)
WHERE app.name == relations.app AND related.name == relations.related
MERGE (app)-[:related{kind:relations.kind}]->(related)


WITH count(*) as dummy


/* Create reviews with information of reviews.csv */
LOAD CSV WITH HEADERS FROM 'file:///reviews.csv' AS reviews
MERGE (review:Review {id:reviews.reviewID, overall:reviews.overall, review:reviews.review})
MERGE (reviewer:Reviewer {id:reviews.reviewerID, name:reviews.reviewerName})
MERGE (reviewer)-[:writeReview]->(review)
MATCH (app:App)
WHERE app.name == reviews.app
MERGE (app)<-[:review]-(review)
