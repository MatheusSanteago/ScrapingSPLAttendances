-- DDL Commands

CREATE TABLE IF NOT EXISTS dim_stadiums (
ID INT PRIMARY KEY,
Stadium VARCHAR(120),
Club VARCHAR(120));

CREATE TABLE IF NOT EXISTS dim_clubs (
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

CREATE TABLE IF NOT EXISTS dim_transfers (
  id INT PRIMARY KEY,
  club_id INT,
  country VARCHAR(30),
  player_name VARCHAR(60),
  age INT,
  position VARCHAR(20),	
  club_involved_name VARCHAR(60),	
  club_involved_country VARCHAR(60),	
  transfer_movement VARCHAR(3),	
  transfer_period VARCHAR(10),	
  year INT,    
  FOREIGN KEY(club_id) REFERENCES dim_clubs(id));
  
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
    FOREIGN KEY(Club_ID) REFERENCES dim_clubs(ID));


-- DML Commands
WITH qyuery as (
	select dc.id as club_id, country, player_name, "age", "position", club_involved_name, club_involved_country,transfer_movement, transfer_period, "year" from transfers t 
	join dim_clubs dc on t."club_name" = dc."clubs"
	order by "year"
)
INSERT INTO dim_transfers (id, club_id, country, player_name, "age", "position", club_involved_name,club_involved_country, transfer_movement, transfer_period, "year")
select row_number() over (order by "year"  asc) as id, * 
from qyuery;

WITH query_std AS (
    SELECT DISTINCT "Stadium", "Club" 
    FROM attendances
) 
INSERT INTO dim_stadiums ("id", "stadium", "club")
SELECT row_number() over (order by "Stadium"  asc) as id, *
FROM query_std;
    
WITH query_teams AS (
  SELECT DISTINCT 
	"Clubs", "Players", "avg_age", "Foreigners", "market_value(€)", "total_market_value(€)", "League" 
	FROM teams
) 
INSERT INTO dim_teams (ID, Clubs, Players, avg_age, Foreigners, "market_value(€)", "total_market_value(€)", League)
SELECT row_number() OVER (ORDER BY "Clubs" ASC) as id, * 
FROM query_teams;

WITH query_t AS (
SELECT 
	dt.id as club_id, count(CASE WHEN qc."League" = 'Yelo League' THEN 1 ELSE 0 END) as YeloLeague, --- Only count if condition is True
  count(CASE WHEN qc."League" = 'Saudi Pro League' THEN 1 ELSE 0 END) as SaudiProLeague -- Only count if condition is True
	FROM champions qc
	JOIN dim_teams dt ON qc."Clubs" = dt."clubs"
GROUP BY qc."Clubs", dt.id)
INSERT INTO dim_trophies (Club_ID, YeloLeague, SaudiProLeague)
SELECT * FROM query_t;

WITH fact AS (
	SELECT ds.id AS Stadium_ID, dt.id as Team_id, a."Capacity", a."Spectators" , a."Average", a."Matches", a."sold out", a."Year" 
  FROM attendances a
	JOIN dim_stadiums ds ON a."Stadium" = ds."stadium"
	JOIN dim_clubs dt ON a."Club" = dt."clubs"
	ORDER BY "Year"
)

INSERT INTO fact_attendances (ID, Stadium_ID, Club_ID, Capacity, Spectators, Average, Matches, "sold out", "year")
SELECT ROW_NUMBER() OVER (ORDER BY "Year"  ASC) AS id, * 
FROM fact;
 