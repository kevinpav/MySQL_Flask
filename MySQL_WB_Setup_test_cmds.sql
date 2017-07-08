-- Example commands for MySQL Workbench testing.

-- Use the twitter schema
use twitter

-- Get listing of all user records
select * from users;

-- Get all tweets
select * from tweets;

-- Tweets by user
select users.handle ID, tweets.tweet tweet
from tweets
join users where users.id = tweets.user_id;

-- Tweets ordered by date
select DATE_FORMAT(tweets.created_at, "%M %d %Y"), users.handle ID, tweets.tweet tweet
from tweets
join users where users.id = tweets.user_id
order by tweets.created_at asc;
