USE Cyclistic_Raw;

-- For the purpose of the further analysis, 2 new columns will be added: ride_length and day_of_week
ALTER TABLE dbo.data2201 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2202 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2203 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2204 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2205 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2206 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2207 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2208 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2209 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2210 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2211 ADD ride_length int, day_of_week tinyint;
ALTER TABLE dbo.data2212 ADD ride_length int, day_of_week tinyint;

-- Fill values into the newly added columns (dw starts with 1 (Sunday) to 7 (Saturday)
UPDATE dbo.data2201 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2202 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2203 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2204 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2205 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2206 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2207 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2208 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2209 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2210 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2211 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);
UPDATE dbo.data2212 SET ride_length = DATEDIFF(ss, started_at, ended_at), day_of_week = DATEPART(dw,started_at);

-- Re Run The pre-cleaning EDA to make sure everything is cleaned.
-- To make this process easier, we will create a new table to accomodate everything within data2201 to data2212 to make it faster than using the VIEW we created before.
CREATE TABLE alldata22 (
	ride_id nvarchar(MAX),
	rideable_type nvarchar(MAX),
	started_at DATETIME2,
	ended_at DATETIME2,
	start_station_name nvarchar(MAX),
	start_station_id nvarchar(MAX),
	end_station_name nvarchar(MAX),
	end_station_id nvarchar(MAX),
	start_lat decimal(15, 12),
	start_lng decimal(15, 12),
	end_lat decimal(15, 12),
	end_lng decimal(15, 12),
	member_casual nvarchar(MAX),
	ride_length int,
	day_of_week tinyint
	);

INSERT INTO dbo.alldata22
SELECT * FROM dbo.data2201
UNION
SELECT * FROM dbo.data2202
UNION
SELECT * FROM dbo.data2203
UNION
SELECT * FROM dbo.data2204
UNION
SELECT * FROM dbo.data2205
UNION
SELECT * FROM dbo.data2206
UNION
SELECT * FROM dbo.data2207
UNION
SELECT * FROM dbo.data2208
UNION
SELECT * FROM dbo.data2209
UNION
SELECT * FROM dbo.data2210
UNION
SELECT * FROM dbo.data2211
UNION
SELECT * FROM dbo.data2212;

SELECT
	COUNT(*) AS all_rows,
	COUNT(ride_id) AS ride_id,
	COUNT(rideable_type) AS rideable_type,
	COUNT(started_at) AS started_at,
	COUNT(ended_at) AS ended_at,
	COUNT(start_station_name) AS start_station_name,
	COUNT(start_station_id) AS start_station_id,
	COUNT(end_station_name) AS end_station_name,
	COUNT(end_station_id) AS end_station_id,
	COUNT(start_lat) AS start_lat,
	COUNT(start_lng) AS start_lng,
	COUNT(end_lat) AS end_lat,
	COUNT(end_lng) AS end_lng,
	COUNT(member_casual) AS member_casual,
	COUNT(ride_length) AS ride_length,
	COUNT(day_of_week) AS day_of_week
FROM
	dbo.alldata22;
-- There are 4611531 rows throughout the entire tables and there aren't any NULL values.


--------------------------------------------------------------------
--------------------------------------------------------------------
--> 1. Verify that ride_id is still unique
SELECT COUNT(DISTINCT UPPER(ride_id)) FROM dbo.alldata22; --4611531 which is the same as the row counts

--> 2. Verify there aren't any additional values added towards rideable_type
SELECT DISTINCT rideable_type FROM dbo.alldata22;

--> 3. Make sure everything is within 2022
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.alldata22;

--> 4. Make sure end date also doesn't end before 2022
--Is there data that ends before 2022?
SELECT MIN(ended_at) AS min_end, MAX(ended_at) AS max_end FROM dbo.alldata22;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2201;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2202;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2203;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2204;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2205;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2206;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2207;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2208;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2209;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2210;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2211;
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.data2212;
--There are no data ended before 2022. But there are some data that ends after 2022 (but this makes sense)
SELECT * FROM dbo.alldata22 WHERE DATEPART(YEAR, ended_at) > 2022;
--There are 42 rows of data that started at 2022, but ended at 2023

--> 5. Make sure there are no longer any data that ends before it starts (started_at > ended_at)
SELECT * FROM dbo.alldata22 WHERE ended_at < started_at;
SELECT COUNT(*) FROM dbo.alldata22 WHERE ended_at < started_at;
-- There is no ride matching this criterion.
SELECT * FROM dbo.alldata22 WHERE ended_at = started_at;
-- There is no ride that starts and ends at the same time.

--> 6. Make sure there are no NULL values inside start_station
SELECT 4611531 - COUNT(start_station_name) FROM dbo.alldata22;
SELECT 4611531 - COUNT(start_station_id) FROM dbo.alldata22;

SELECT * FROM dbo.alldata22 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL; --no data
SELECT * FROM dbo.alldata22 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL; --no data

--The relationship b/w the two should be one on one.
SELECT COUNT(DISTINCT start_station_id) AS id_count, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.alldata22;

--> 7. Make sure there are no NULL values inside end_station
SELECT 4611531 - COUNT(end_station_name) FROM dbo.alldata22;
SELECT 4611531 - COUNT(end_station_id) FROM dbo.alldata22;

SELECT * FROM dbo.alldata22 WHERE end_station_id IS NULL AND end_station_name IS NOT NULL; --no data
SELECT * FROM dbo.alldata22 WHERE end_station_id IS NOT NULL AND end_station_name IS NULL; --no data

--The relationship b/w the two should be one on one.
SELECT COUNT(DISTINCT end_station_id) AS id_count, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.alldata22;


--> 8. start_lat and start_lng
--What are the min and max start_lat?
SELECT MIN(start_lat), MAX(start_lat) FROM dbo.alldata22;
--! Lowest = 41.648500762664, Highest = 45.63503432300000
--What are the min and max start_lng?
SELECT MIN(start_lng), MAX(start_lng) FROM dbo.alldata22;
--! Lowest = -87.833320500000, Highest = -73.79647696000000
-- Since there are too many datas inside, I haven't found a way to generate reverse geocoding to check if all the coords are in fact within Chicago

--> 9. end_lat and end_lng
--What are the min and max start_lat?
SELECT MIN(end_lat), MAX(end_lat) FROM dbo.alldata22;
--! The lowest lat=0 and the highest lat= 42.064854000000
--What are the min and max start_lng?
SELECT MIN(end_lng), MAX(end_lng) FROM dbo.alldata22;
--! The lowest lng = -87.830000000000, the hithest lng=0
SELECT * FROM dbo.alldata22 WHERE end_lat = 0 OR end_lng = 0; -- it turns out everything is within december dataset. There are 8 rows
-- Clean those rows
DELETE FROM dbo.data2211 WHERE end_lat = 0 OR end_lng = 0;
DELETE FROM dbo.alldata22 WHERE end_lat = 0 OR end_lng = 0;

--What are the min and max start_lat after cleaning?
SELECT MIN(end_lat), MAX(end_lat) FROM dbo.alldata22;
--! The lowest lat=41.648500762664 and the highest lat= 42.064854000000
--What are the min and max start_lng?
SELECT MIN(end_lng), MAX(end_lng) FROM dbo.alldata22;
--! The lowest lng = -87.830000000000, the hithest lng=-87.528231739998


--> 10. member
SELECT COUNT(DISTINCT member_casual) FROM dbo.alldata22;
SELECT DISTINCT member_casual FROM dbo.alldata22;
--There are only 2 values: member, casual

--> 11. ride_length
SELECT MIN(ride_length) AS min, MAX(ride_length) AS max from dbo.alldata22;
SELECT TOP (25) ride_length AS max from dbo.alldata22 ORDER BY ride_length DESC;
-- The min is 1 second. Since we are trying to learn the riding pattern of our users, one-second ride is not very intuitive. It is not quite possible to have ride within a second.
--Therefore all rides under 60 seconds will be removed (because on analysis, we will convert this into minute. data under 60 seconds will show as 0 minute). However the max one (~23 days) cannot be removed since we don't have data that it can't be used overnight.
SELECT COUNT(*) FROM dbo.alldata22 WHERE ride_length < 60;

DELETE FROM dbo.data2201 WHERE ride_length < 60;
DELETE FROM dbo.data2202 WHERE ride_length < 60;
DELETE FROM dbo.data2203 WHERE ride_length < 60;
DELETE FROM dbo.data2204 WHERE ride_length < 60;
DELETE FROM dbo.data2205 WHERE ride_length < 60;
DELETE FROM dbo.data2206 WHERE ride_length < 60;
DELETE FROM dbo.data2207 WHERE ride_length < 60;
DELETE FROM dbo.data2208 WHERE ride_length < 60;
DELETE FROM dbo.data2209 WHERE ride_length < 60;
DELETE FROM dbo.data2210 WHERE ride_length < 60;
DELETE FROM dbo.data2211 WHERE ride_length < 60;
DELETE FROM dbo.data2212 WHERE ride_length < 60;
DELETE FROM dbo.alldata22 WHERE ride_length < 60;

SELECT COUNT(*) FROM dbo.data2201;
SELECT COUNT(*) FROM dbo.data2202;
SELECT COUNT(*) FROM dbo.data2203;
SELECT COUNT(*) FROM dbo.data2204;
SELECT COUNT(*) FROM dbo.data2205;
SELECT COUNT(*) FROM dbo.data2206;
SELECT COUNT(*) FROM dbo.data2207;
SELECT COUNT(*) FROM dbo.data2208;
SELECT COUNT(*) FROM dbo.data2209;
SELECT COUNT(*) FROM dbo.data2210;
SELECT COUNT(*) FROM dbo.data2211;
SELECT COUNT(*) FROM dbo.data2212;
SELECT COUNT(*) FROM dbo.alldata22;



SELECT DISTINCT day_of_week FROM dbo.alldata22;



---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Summary Statistics before Analysis in R
SELECT DATEPART(MONTH, started_at) AS data_month, COUNT(*) AS data_count FROM dbo.alldata22 GROUP BY DATEPART(MONTH, started_at) ORDER BY data_count DESC;
-- July has the most rides and January has the least rides.
-- Rides are popular from May till October.

-- month by member_casual
WITH rides_month AS (
SELECT * FROM 
(
	SELECT DATEPART(MONTH, started_at) AS data_month, member_casual, ride_id FROM dbo.alldata22
) AS MemberResult
PIVOT
(
	COUNT(ride_id) FOR member_casual IN ([casual], [member])
) AS Pivot_Member)
SELECT *, casual+member AS total FROM rides_month ORDER BY data_month;
-- There are more member rides compared to casual rides. It is consistent throughout the year.
-- The lowest number of rides recorded are in January and February.


WITH rides_day AS (
SELECT * FROM 
(
	SELECT day_of_week, member_casual, ride_id FROM dbo.alldata22
) AS MemberResult
PIVOT
(
	COUNT(ride_id) FOR member_casual IN ([casual], [member])
) AS Pivot_Member)
SELECT *, casual+member AS total FROM rides_day ORDER BY day_of_week;
-- Saturday is the busiest day overall and Over all day of week, Casual riders ride the most on Saturday and Sunday.
-- However that is not the case for member riders. Most member riders are quite consistent although there are more rides happening on weekdays.


--Average ride_length in minutes for each day of week among member and casual riders
WITH avg_length_day AS (
SELECT * FROM 
(
	SELECT day_of_week, member_casual, ROUND(CAST(ride_length AS DECIMAL) / 60, 0) AS ride_length FROM dbo.alldata22
) AS MemberResult
PIVOT
(
	AVG(ride_length) FOR member_casual IN ([casual], [member])
) AS Pivot_Member)
SELECT * FROM avg_length_day ORDER BY day_of_week;
-- Casual riders ride longer than member riders.
-- Rides are longer on the weekend among casual and member.

WITH avg_length_month AS (
SELECT * FROM 
(
	SELECT DATEPART(MONTH, started_at) AS data_month, member_casual, ROUND(CAST(ride_length AS DECIMAL) / 60, 0) AS ride_length FROM dbo.alldata22
) AS MemberResult
PIVOT
(
	AVG(ride_length) FOR member_casual IN ([casual], [member])
) AS Pivot_Member)
SELECT * FROM avg_length_month ORDER BY data_month;
-- There are significant decrease in average ride_length for casual riders on November and December.


SELECT DATEPART(MONTH, started_at) AS data_month, AVG(ride_length) / 60.0 AS avg_length FROM dbo.alldata22 GROUP BY DATEPART(MONTH, started_at) ORDER BY data_month;


SELECT AVG(CAST(ride_length AS DECIMAL)) / 60 AS avg_ride_length FROM dbo.alldata22; --17.184113 minute
SELECT MAX(CAST(ride_length AS DECIMAL)) / 60 AS avg_ride_length FROM dbo.alldata22; -- 34354.066666 minute
SELECT MIN(CAST(ride_length AS DECIMAL)) / 60 AS avg_ride_length FROM dbo.alldata22; --1 minute
SELECT day_of_week, COUNT(*) AS day_count FROM dbo.alldata22 GROUP BY day_of_week ORDER BY day_count DESC; -- Saturday is the mode of the data

-- The most popular start_station
SELECT start_station_name, COUNT(*) AS ride_count FROM dbo.alldata22 GROUP BY start_station_name ORDER BY ride_count DESC; --Streeter Dr & Grand Ave
SELECT end_station_name, COUNT(*) AS ride_count FROM dbo.alldata22 GROUP BY end_station_name ORDER BY ride_count DESC; --Streeter Dr & Grand Ave