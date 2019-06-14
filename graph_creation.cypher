/* Create app with the information provided by app.csv */
LOAD CSV WITH HEADERS FROM 'file:///app_reduced.csv' AS app

MERGE (application:App {name:app.app, price:app.price, rating:app.rating})


WITH count(*) as dummy


LOAD CSV WITH HEADERS FROM 'file:///categories.csv' AS categories
MERGE (:Category {name:categories.category})


WITH count(*) as dummy


LOAD CSV WITH HEADERS FROM 'file:///categories.csv' AS categories
MATCH (app:App), (cat:Category)
WHERE app.name = categories.app AND cat.name = categories.category
MERGE (app)-[:hasCategory]->(cat)


WITH count(*) as dummy


/* Create relations with the information provided by categories.csv */
LOAD CSV WITH HEADERS FROM 'file:///related.csv' AS relations
MATCH (app:App), (related:App)
WHERE app.name = relations.app AND related.name = relations.related
MERGE (app)-[:related{kind:relations.kind}]->(related)


WITH count(*) as dummy


/* Create reviews with information of reviews.csv */
LOAD CSV WITH HEADERS FROM 'file:///reviews.csv' AS reviews
MATCH (app:App)
WHERE app.name = reviews.app
MERGE (review:Review {id:reviews.reviewID, overall:reviews.overall, review:reviews.review})
MERGE (reviewer:Reviewer {id:reviews.reviewerID, name:reviews.reviewerName})
MERGE (reviewer)-[:writeReview]->(review)
MERGE (app)<-[:review]-(review)
