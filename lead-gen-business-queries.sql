-- Queries
-- 1. What query would you run to get the total revenue for March of 2012?
select monthname(charged_datetime), sum(amount) from billing
where charged_datetime between '2012-03-01' and '2012-03-31'
group by month(charged_datetime);

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
select client_id, sum(amount) from billing
where client_id = 2;

-- 3. What query would you run to get all the sites that client=10 owns?
select domain_name, client_id from sites
where client_id = 10;

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1?
-- What about for client=20?
select client_id, count(created_datetime), monthname(created_datetime), year(created_datetime)
from sites
where client_id=1
group by month(created_datetime)
order by created_datetime asc;

select client_id, count(created_datetime), monthname(created_datetime), year(created_datetime)
from sites
where client_id=20
group by month(created_datetime)
order by created_datetime asc;

-- 5. What query would you run to get the total # of leads generated for each of the sites
-- between January 1, 2011 to February 15, 2011?
select s.domain_name, count(l.leads_id), l.registered_datetime
from sites s
join leads l on s.site_id = l.site_id
where created_datetime between '2011-01-01' and '2011-02-15'
group by s.domain_name;

-- 6. What query would you run to get a list of client names and the total # of leads we've generated
-- for each of our clients between January 1, 2011 to December 31, 2011?
select concat_ws(' ', c.first_name, c.last_name), count(l.leads_id)
from clients c
join sites s on c.client_id = s.client_id
join leads l on s.site_id = l.site_id
where c.joined_datetime between '2011-01-01' and '2011-12-31'
group by c.client_id;

-- 7. What query would you run to get a list of client names and the total # of leads we've generated
-- for each client each month between months 1 - 6 of Year 2011?
select concat_ws(' ', c.first_name, c.last_name), count(l.leads_id), monthname(l.registered_datetime)
from clients c
join sites s on c.client_id = s.client_id
join leads l on s.site_id = l.site_id
where l.registered_datetime between '2011-01-01' and '2011-06-30'
group by c.client_id, month(l.registered_datetime);

-- 8. What query would you run to get a list of client names and the total # of leads we've generated
-- for each of our clients' sites between January 1, 2011 to December 31, 2011? Order this query by client id.
--  Come up with a second query that shows all the clients, the site name(s), and the total number of leads
-- generated from each site for all time.
select concat_ws(' ', c.first_name, c.last_name), s.domain_name, count(l.leads_id)
from clients c
join sites s on c.client_id = s.client_id
join leads l on s.site_id = l.site_id
where l.registered_datetime between '2011-01-01' and '2011-12-31'
group by c.client_id, s.site_id
order by c.client_id;

select concat_ws(' ', c.first_name, c.last_name), s.domain_name, count(l.leads_id)
from clients c
join sites s on c.client_id = s.client_id
join leads l on s.site_id = l.site_id
group by c.client_id, s.site_id
order by c.client_id;

-- 9. Write a single query that retrieves total revenue collected from each client for each month of the year.
-- Order it by client id.
select concat_ws(' ', c.first_name, c.last_name) Client_Name, sum(b.amount) Total_Revenue,
		monthname(b.charged_datetime) Month_Charge, year(b.charged_datetime) Year_charge
from clients c
join billing b on c.client_id = b.client_id
group by c.last_name, c.first_name, year(b.charged_datetime), month(b.charged_datetime);

-- 10. Write a single query that retrieves all the sites that each client owns.
-- Group the results so that each row shows a new client.
-- It will become clearer when you add a new field called 'sites' that has all the sites that the client owns.
-- (HINT: use GROUP_CONCAT)
select concat_ws(' ', c.first_name, c.last_name) Client_Name,
		group_concat(distinct s.domain_name order by s.domain_name asc separator ' / ') Sites
from clients c
join sites s on c.client_id = s.client_id
group by 1;
