-- Using the below ERD, write the SQL query that returns a list of users along with their friends' names.

-- Create the tables and populate them with some fake data.  Your results should look like below:

-- first_name	last_name	friend_first_name	friend_last_name
-- Chris	Baker	Jessica	Davidson
-- Chris	Baker	James	Johnson
-- Chris	Baker	Diana	Smith
-- Diana	Smith	Chris	Baker
-- James	Johnson	Chris	Baker
-- Jessica	Davidson	Chris	Baker


select u.first_name, u.last_name, u2.first_name friend_first_name, u2.last_name friend_last_name from users u
left join friendships f on u.id = f.user_id
left join users as u2 on u2.id = f.friend_id;