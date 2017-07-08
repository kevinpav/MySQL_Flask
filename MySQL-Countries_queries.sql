-- Queries

-- 1. What query would you run to get all the countries that speak Slovene?
-- Your query should return the name of the country, language and language percentage.
-- Your query should arrange the result by language percentage in descending order. (1)
select countries.name Country, languages.language Language, languages.percentage
from countries
join languages where countries.id = languages.country_id AND languages.language = 'Slovene'
order by percentage desc;

-- 2. What query would you run to display the total number of cities for each country?
-- Your query should return the name of the country and the total number of cities.
-- Your query should arrange the result by the number of cities in descending order. (3)
select countries.name Country, count(cities.id) NumCities
from countries
join cities where countries.id = cities.country_id
group by cities.country_id
order by NumCities desc;

-- 3. What query would you run to get all the cities in Mexico with a population of greater than 500,000?
-- Your query should arrange the result by population in descending order. (1)
select cities.name, cities.population
from cities
join countries where countries.id = cities.country_id AND countries.name = 'Mexico'
and cities.population > 500000;

-- 4. What query would you run to get all languages in each country with a percentage greater than 89%?
-- Your query should arrange the result by percentage in descending order. (1)
-- Note: did this without the JOIN clause. How I learned sql. Old School?
select c.name, l.language, l.percentage
from countries c, languages l
where c.id = l.country_id
and l.percentage > 89
order by l.percentage desc;

-- 5. What query would you run to get all the countries with Surface Area below 501 and Population greater than 100,000? (2)
select c.name, c.surface_area, c.population
from countries c
where c.surface_area < 501
and c.population > 100000;

-- 6. What query would you run to get countries with only Constitutional Monarchy
-- with a capital greater than 200 and a life expectancy greater than 75 years? (1)
select c.name, c.government_form, c.capital, c.life_expectancy
from countries c
where c.capital > 200
and c.life_expectancy > 75
and c.government_form = 'Constitutional Monarchy'
order by c.name;

-- 7. What query would you run to get all the cities of Argentina inside the Buenos Aires district
-- and have the population greater than 500, 000?
-- The query should return the Country Name, City Name, District and Population. (2)
select c.name, t.name, t.district, t.population
from cities t
join countries c
where t.country_id = c.id
and t.population > 500000
and t.district = 'Buenos Aires'
order by t.population desc;

-- 8. What query would you run to summarize the number of countries in each region?
-- The query should display the name of the region and the number of countries.
-- Also, the query should arrange the result by the number of countries in descending order. (2)
select c.region, count(c.id) count
from countries c
group by c.region
order by count desc;