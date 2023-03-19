USE Cyclistic_Raw;
--First we count rows inside each table
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

--Then we create a VIEW joining every table vertically to ease the pre-cleaning exploration process.
CREATE VIEW all_combined AS
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
SELECT * FROM dbo.data2212
;

--Count non null values of the data
--Check non-null value for each columns
SELECT 
	COUNT(*),
	COUNT(ride_id), 
	COUNT(rideable_type), 
	COUNT(started_at), 
	COUNT(ended_at), 
	COUNT(start_station_name), 
	COUNT(start_station_id), 
	COUNT(end_station_name), 
	COUNT(end_station_id), 
	COUNT(start_lat), 
	COUNT(start_lng), 
	COUNT(end_lat), 
	COUNT(end_lng), 
	COUNT(member_casual) 
FROM dbo.all_combined;
--There are some missing data within start_station_name, start_station_id, end_station_name, end_station_id, end_lat, end_lng

---------------------------------------------------
---------------------------------------------------
-- Here begins the pre-cleaning exploration process:
----> Col 1 : ride_id
--ride_id should be unique. Let's check if the value is unique
SELECT COUNT(DISTINCT ride_id) AS ride_id_count FROM dbo.all_combined;
SELECT COUNT(DISTINCT UPPER(ride_id)) FROM dbo.all_combined; --this should equal the entire rows. And indeed it does (566717)
--! Checked: There are no duplicate ride_id

--some overview of the data
SELECT * FROM dbo.all_combined ORDER BY ride_id ASC;
SELECT * FROM dbo.all_combined ORDER BY ride_id DESC;

--let's check if the number of character within each ride_id is equal
SELECT LEN(ride_id) FROM dbo.all_combined GROUP BY LEN(ride_id);
--! all are 16 characters

--is there any space within ride_id
SELECT CHARINDEX(' ', ride_id) FROM dbo.all_combined GROUP BY CHARINDEX(' ', ride_id);
--there aren't any space within
--## Looks like the ride_id column is pretty clean

----> Col 2 : rideable_type (no missing values)
--let's see how unique the data is
SELECT COUNT(DISTINCT rideable_type) FROM dbo.all_combined;
--There are only three distinct values for rideable_type
SELECT DISTINCT rideable_type FROM dbo.all_combined;
--! They are electric_bike, classic_bike and docked_bike
--## This column is quite clean


----> Col 3: started_at (no missing values)
--The timeline is 2022. Is there data that starts before 2022?
SELECT MIN(started_at) AS min_date, MAX(started_at) AS max_date FROM dbo.all_combined;
--! Everything is within 2022

----> Col 4: ended_at (no missing values)
--Is there data that ends before 2022?
SELECT MIN(ended_at) AS min_end, MAX(ended_at) AS max_end FROM dbo.all_combined;
--There are no data ended before 2022. But there are some data that ends after 2022 (but this makes sense)
SELECT * FROM dbo.all_combined WHERE DATEPART(YEAR, ended_at) > 2022;
--There are 61 rows of data that started at 2022, but ended at 2023

---->?? Col 3 and 4: relationship b/w start and end date
--Is there data that has end date before start date?
SELECT * FROM dbo.all_combined WHERE ended_at < started_at;
SELECT COUNT(*) FROM dbo.all_combined WHERE ended_at < started_at;
--# CLEAN!!! There are exactly 100 rows that match this condition.

SELECT * FROM dbo.all_combined WHERE ended_at = started_at;
--# Clean!!! There are 431 rows that match this condition



----> Col 5: start_station_name (there are missing values)
SELECT 5667717 - COUNT(start_station_name) FROM dbo.all_combined;
 -- there are 833,064 missing data

SELECT COUNT(DISTINCT start_station_name) FROM dbo.all_combined; -- How many stations are there in the data
--! There are 1674 unique station_name in start_station_name
SELECT DISTINCT TOP(50) start_station_name FROM dbo.all_combined ORDER BY start_station_name;
SELECT DISTINCT TOP(50) start_station_name FROM dbo.all_combined ORDER BY start_station_name DESC;


----> Col 6: start_station_id (there are missing values)
SELECT 5667717 - COUNT(start_station_id) FROM dbo.all_combined;
-- there are 833064 missing data

SELECT COUNT(DISTINCT start_station_id) FROM dbo.all_combined; -- How many stations are there in the data
-- there are 1313 unique start_station_id which is less than the number of unique start_station_name (1674-1313 = 361)
SELECT DISTINCT TOP(50) start_station_id FROM dbo.all_combined ORDER BY start_station_id;
SELECT DISTINCT TOP(50) start_station_id FROM dbo.all_combined ORDER BY start_station_id DESC;

---->?? Relationship between start_station_id and start_station_name. 
SELECT * FROM dbo.all_combined WHERE start_station_id IS NULL AND start_station_name IS NOT NULL; --no data
SELECT * FROM dbo.all_combined WHERE start_station_id IS NOT NULL AND start_station_name IS NULL; --no data
-- The 833064 within both are coming from the same rows.

--The relationship b/w the two should be one on one.
SELECT COUNT(DISTINCT start_station_id) AS id_count, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.all_combined;

-- How many id that have multiple names?
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.all_combined GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
--There are 329 ids that refer to multiple names

--What about the name? Can one name have multiple start_station_id?
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.all_combined GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
--There are 18 names that have 2 ids
SELECT DISTINCT start_station_id, start_station_name FROM dbo.all_combined WHERE start_station_name IN (SELECT start_station_name FROM dbo.all_combined GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1) ORDER BY start_station_name;

--How many rows contain id that refer to multiple names?
SELECT COUNT(*) FROM dbo.all_combined WHERE start_station_id IN (SELECT start_station_id FROM dbo.all_combined GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--There are 270867 rows related to those ids.

--How many rows contain name that can be referred by more than 1 ids?
SELECT COUNT(*) FROM dbo.all_combined WHERE start_station_name IN (SELECT start_station_name FROM dbo.all_combined GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1);
--There are 31513 rows related to those names;
select distinct start_station_id from dbo.all_combined where start_station_name = 'Bissell St & Armitage Ave';
--What about both?
SELECT COUNT(*) FROM dbo.all_combined WHERE start_station_id IN (SELECT start_station_id FROM dbo.all_combined GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1) AND start_station_name IN (SELECT start_station_name FROM dbo.all_combined GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1);
--There are 934 rows that intersect in both data.



----> Col 7: end_station_name (with missing values)
SELECT 5667717 - COUNT(end_station_name) FROM dbo.all_combined;
 -- there are 892,742 missing data

SELECT COUNT(DISTINCT end_station_name) FROM dbo.all_combined; -- How many stations are there in the data
--! There are 1692 unique station_name in end_station_name
SELECT DISTINCT TOP(50) end_station_name FROM dbo.all_combined ORDER BY end_station_name;
SELECT DISTINCT TOP(50) end_station_name FROM dbo.all_combined ORDER BY end_station_name DESC;


----> Col 8: end_station_id (there are missing values)
SELECT 5667717 - COUNT(end_station_id) FROM dbo.all_combined;
-- there are 892,742 missing data

SELECT COUNT(DISTINCT end_station_id) FROM dbo.all_combined; -- How many stations are there in the data
-- there are 1317 unique end_station_id which is less than the number of unique start_station_name (1692-1317 = 375)
SELECT DISTINCT TOP(50) end_station_id FROM dbo.all_combined ORDER BY end_station_id;
SELECT DISTINCT TOP(50) end_station_id FROM dbo.all_combined ORDER BY end_station_id DESC;

---->?? Relationship between end_station_id and end_station_name. 
SELECT * FROM dbo.all_combined WHERE end_station_id IS NULL AND end_station_name IS NOT NULL; --no data
SELECT * FROM dbo.all_combined WHERE end_station_id IS NOT NULL AND end_station_name IS NULL; --no data
-- The 892,742 within both are coming from the same rows.

--The relationship b/w the two should be one on one.
SELECT COUNT(DISTINCT end_station_id) AS id_count, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.all_combined;
--The count is different. 

-- How many id that have multiple names?
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.all_combined GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
--There are 339 ids that refer to multiple names

--What about the name? Can one name have multiple end_station_id?
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.all_combined GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
--There are 18  names that have 2 ids
SELECT DISTINCT end_station_id, end_station_name FROM dbo.all_combined WHERE end_station_name IN (SELECT end_station_name FROM dbo.all_combined GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1) ORDER BY end_station_name;

--How many rows contain id that refer to multiple names?
SELECT COUNT(*) FROM dbo.all_combined WHERE end_station_id IN (SELECT end_station_id FROM dbo.all_combined GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);
--There are 299703 rows related to those ids.

--How many rows contain name that can be referred by more than 1 ids?
SELECT COUNT(*) FROM dbo.all_combined WHERE end_station_name IN (SELECT end_station_name FROM dbo.all_combined GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1);
--There are 31343 rows related to those names;

--What about both?
SELECT COUNT(*) FROM dbo.all_combined WHERE end_station_id IN (SELECT end_station_id FROM dbo.all_combined GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1) AND end_station_name IN (SELECT end_station_name FROM dbo.all_combined GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1);
--There are 850 rows that intersect in both data.


----> Col 9 and 10: start lat and lng
-- How many unique values are there?
SELECT DISTINCT start_lat, start_lng FROM dbo.all_combined;
--There are 1952378 unique values

--What are the min and max start_lat?
SELECT MIN(start_lat), MAX(start_lat) FROM dbo.all_combined;
--! Lowest = 41.64000000000000, Highest = 45.63503432300000
--What are the min and max start_lng?
SELECT MIN(start_lng), MAX(start_lng) FROM dbo.all_combined;
--! Lowest = -87.84000000000000, Highest = -73.79647696000000
--# There is limitation. I notice some of the lat,lng aren't in Chicago. 
--# However, since the data is too big, we can't initiate reverse geocoding

-- Start_station_id = start_station_name
SELECT * FROM dbo.all_combined WHERE start_station_id = start_station_name;
-- There are 58 rows;
SELECT DISTINCT start_station_id, start_station_name from dbo.all_combined WHERE start_station_name IN (SELECT start_station_name FROM dbo.all_combined WHERE start_station_id = start_station_name) ORDER BY start_station_name;

----> Col 11 and 12: end lat and lng
-- How many unique values are there?
SELECT DISTINCT end_lat, end_lng FROM dbo.all_combined;
--There are 2430 unique values

--What are the min and max start_lat?
SELECT MIN(end_lat), MAX(end_lat) FROM dbo.all_combined;
--! The lowest lat=0 and the highest lat= 42.37000000000000
--What are the min and max start_lng?
SELECT MIN(end_lng), MAX(end_lng) FROM dbo.all_combined;
--! The lowest lng = -88.14, the hithest lng=0
--# CLEAN!!! The lat and lng with 0
SELECT * FROM dbo.all_combined WHERE end_lat = 0 OR end_lng = 0;
--! There are 8 records;


----> Col 13 : member_casual
SELECT COUNT(DISTINCT member_casual) FROM dbo.all_combined;
SELECT DISTINCT member_casual FROM dbo.all_combined;
--There are only 2 values: member, casual
