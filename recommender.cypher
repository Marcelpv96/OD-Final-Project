// get average review overall (for heuristic)

MATCH (:Reviewer)-[:writeReview]->(r:Review)
RETURN AVG(toFloat(r.overall))

// list users and their apps (to find target)

MATCH (u:Reviewer)-[:writeReview]->(:Review)-[:review]->(a:App)
RETURN u.id AS user, u.name AS name, COLLECT(a.name) AS apps

// get recommendations (sorted by score)

MATCH (t:Reviewer {name : "Douglas Smith"})-[:writeReview]->(:Review)-[:review]->(a1:App),
      (a1:App)-[:hasCategory]->(cat:Category)<-[:hasCategory]-(a2:App)
// find apps that other users have reviewed
OPTIONAL MATCH
      (f:Reviewer)-[:writeReview]->(:Review)-[:review]->(a1:App),
      (f:Reviewer)-[:writeReview]->(rev:Review)-[:review]->(a2:App)
// find related apps
OPTIONAL MATCH
      (a1:App)-[rel:related]-(a2:App)
// avoid trivial case
WHERE a1 <> a2
// compute scores by components
WITH a2.name AS target, AVG(toFloat(rev.overall)) AS ratScore,
     COUNT(DISTINCT cat) AS catScore, COUNT(DISTINCT f) AS userScore, COUNT(DISTINCT rel) AS relScore
// handle no-reviews case
WITH CASE WHEN ratScore IS NULL THEN 4.21 ELSE ratScore END AS ratScore,
     target, catScore, userScore, relScore
// sum components
RETURN target, ratScore + catScore + userScore + relScore AS score
ORDER BY score DESC
