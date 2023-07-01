-- indexes increase queries but slow down write and increase the size of your table. The are like binary trees.
EXPLAIN SELECT customer_id 
From customers
where state = 'CA';

CREATE INDEX idx_state
ON customers(state);

EXPLAIN SELECT *
From customers
where points > 1000;

CREATE INDEX idx_points
ON customers(points);

SHOW INDEXES IN customers;

ANALYZE TABLE customers;

-- prefixx an index for string like vachar, chart, txt ext..
CREATE INDEX idxz_lastname
ON customers(last_name(20));

-- full text index
SELECT * FROM sql_blog.posts;

CREATE FULLTEXT INDEX indx_title_body
ON sql_blog.posts (title, body);

SELECT *, MATCH(title, body) AGAINST ('react redux')
FROM sql_blog.posts
WHERE MATCH(title, body) AGAINST ('react redux');

-- THIS QUERY EXCLUDES REDUX IN THE RETURN STATEMENT THAT'S WHY WE ADDED THE IN BO MODE AND THE - SIGN IN FRONT OF REDUX
SELECT *, MATCH(title, body) AGAINST ('react redux')
FROM sql_blog.posts
WHERE MATCH(title, body) AGAINST ('react -redux' IN BOOLEAN MODE);

-- this add the +form which require that the result text contains the word 'form' in it'
SELECT *, MATCH(title, body) AGAINST ('react redux')
FROM sql_blog.posts
WHERE MATCH(title, body) AGAINST ('react redux +form'  IN BOOLEAN MODE);

-- THIS QUERY RETURNS AN EXACT PHASE IN IT TITLE 
SELECT *, MATCH(title, body) AGAINST ('react redux')
FROM sql_blog.posts
WHERE MATCH(title, body) AGAINST ('"handling a form in react"')