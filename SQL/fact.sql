CREATE OR REPLACE VIEW dim_trophies as
select 
	dt.id as club_id, count(CASE WHEN qc."League" = 'Yelo League' THEN 1 ELSE 0 END) as YeloLeague, count(CASE WHEN qc."League" = 'Saudi Pro League' THEN 1 ELSE 0 END) as SaudiProLeague 
	from champions qc
	join dim_teams dt on qc."Clubs" = dt."Clubs"
group by qc."Clubs", dt.id;

CREATE OR REPLACE VIEW fact_attendances as
	select ds.id as Stadium_ID, dt.id as Team_id, a."Capacity", a."Spectators" , a."Average", a."Matches", a."sold out", a."Year" from attendances a
	join dim_stadiums ds on a."Stadium" = ds."Stadium"
	join dim_teams dt on a."Club" = dt."Clubs"
	order by "Year";


CREATE TABLE IF NOT EXISTS dim_stadiums (
ID INT PRIMARY KEY,
Stadium VARCHAR(120),
Club VARCHAR(120));

CREATE TABLE IF NOT EXISTS dim_teams (
  ID INT PRIMARY KEY,
  Clubs VARCHAR(120), 
  Players INT, 
  avg_age REAL, 
  Foreigners INT, 
  "market_value(€)" REAL, 
  "total_market_value(€)" REAL, 
  League VARCHAR(60));

CREATE TABLE IF NOT EXISTS dim_trophies (
  Club_ID INT PRIMARY KEY,
  YeloLeague INT,
  SaudiProLeague INT,
  FOREIGN KEY(Club_ID) REFERENCES dim_teams(ID));
  
CREATE TABLE IF NOT EXISTS fact_attendances (
    ID INT PRIMARY KEY,
    Stadium_ID INT,
    Club_ID INT,
    Capacity REAL,
    Spectators INT,
    Average REAL,
    Matches INT,
    "sold out" VARCHAR(3),
    Year INT,
    FOREIGN KEY(Stadium_ID) REFERENCES dim_stadiums(ID),
    FOREIGN KEY(Club_ID) REFERENCES dim_teams(ID));


WITH query_std AS (
    SELECT DISTINCT "Stadium", "Club" 
    FROM attendances
) 
INSERT INTO dim_stadiums ("id", "stadium", "club")
SELECT row_number() over (order by "Stadium"  asc) as id, *
FROM query_std;
    

with query_teams as (select distinct 
		"Clubs", "Players", "avg_age", "Foreigners", "market_value(€)", "total_market_value(€)", "League" 
		from teams
) 
INSERT INTO dim_teams (ID, Clubs, Players, avg_age, Foreigners, "market_value(€)", "total_market_value(€)", League)
select row_number() over (order by "Clubs"  asc) as id, * 
from query_teams;

with query_t as (
select 
	dt.id as club_id, count(CASE WHEN qc."League" = 'Yelo League' THEN 1 ELSE 0 END) as YeloLeague, count(CASE WHEN qc."League" = 'Saudi Pro League' THEN 1 ELSE 0 END) as SaudiProLeague 
	from champions qc
	join dim_teams dt on qc."Clubs" = dt."clubs"
group by qc."Clubs", dt.id)
INSERT INTO dim_trophies (Club_ID, YeloLeague, SaudiProLeague)
select * from query_t;

WITH fact as (
	select ds.id as Stadium_ID, dt.id as Team_id, a."Capacity", a."Spectators" , a."Average", a."Matches", a."sold out", a."Year" from attendances a
	join dim_stadiums ds on a."Stadium" = ds."stadium"
	join dim_teams dt on a."Club" = dt."clubs"
	order by "Year"
)

INSERT INTO fact_attendances (ID, Stadium_ID, Club_ID, Capacity, Spectators, Average, Matches, "sold out", "year")
select row_number() over (order by "Year"  asc) as id, * 
from fact;
 