--- Stadiums dimesion view

CREATE OR REPLACE VIEW dim_stadiums AS
with query_std as (
	select distinct "Stadium", "Club" 
	from attendances
) select row_number() over (order by "Stadium"  asc) as id, * from query_std;


--- Teams dimesion view
CREATE OR REPLACE VIEW dim_teams AS
with query_teams as (select distinct 
		"Clubs", "Players", "avg_age", "Foreigners", "market_value(€)", "total_market_value(€)", "League" 
		from teams
) select row_number() over (order by "Clubs"  asc) as id, * from query_teams;

--- Trophies dimesion view
CREATE OR REPLACE VIEW dim_trophies as
select 
	dt.id as club_id, count(CASE WHEN qc."League" = 'Yelo League' THEN 1 ELSE 0 END) as YeloLeague, count(CASE WHEN qc."League" = 'Saudi Pro League' THEN 1 ELSE 0 END) as SaudiProLeague 
	from champions qc
	join dim_teams dt on qc."Clubs" = dt."Clubs"
group by qc."Clubs", dt.id;

--- Attendances fact view

CREATE OR REPLACE VIEW fact_attendances as
	select ds.id as Stadium_ID, dt.id as Team_id, a."Capacity", a."Spectators" , a."Average", a."Matches", a."sold out", a."Year" from attendances a
	join dim_stadiums ds on a."Stadium" = ds."Stadium"
	join dim_teams dt on a."Club" = dt."Clubs"
	order by "Year";