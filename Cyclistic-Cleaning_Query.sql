USE Cyclistic_Raw;

---------------------------------------------------
---------------------------------------------------
-- Here begins the cleaning process:

----> Cleaning 1 : Remove rows that does not have end_station and end_lat, end_lng registered



DELETE FROM dbo.data2201 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 86
DELETE FROM dbo.data2202 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 77 rows
DELETE FROM dbo.data2203 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 266
DELETE FROM dbo.data2204 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 317	
DELETE FROM dbo.data2205 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 722
DELETE FROM dbo.data2206 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 1055
DELETE FROM dbo.data2207 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 947
DELETE FROM dbo.data2208 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 843
DELETE FROM dbo.data2209 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 712 rows
DELETE FROM dbo.data2210 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- -475 rows
DELETE FROM dbo.data2211 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 230
DELETE FROM dbo.data2212 WHERE (end_station_name IS NULL) AND (end_station_id IS NULL) AND (end_lat IS NULL) AND (end_lng IS NULL); -- 128



----> Clean 2 : delete rows that has start date >= end_date
DELETE FROM dbo.data2201 WHERE started_at >= ended_at; -- 5
DELETE FROM dbo.data2202 WHERE started_at >= ended_at; -- 5
DELETE FROM dbo.data2203 WHERE started_at >= ended_at; -- 18
DELETE FROM dbo.data2204 WHERE started_at >= ended_at; -- 31
DELETE FROM dbo.data2205 WHERE started_at >= ended_at; -- 48
DELETE FROM dbo.data2206 WHERE started_at >= ended_at; -- 66
DELETE FROM dbo.data2207 WHERE started_at >= ended_at; -- 72
DELETE FROM dbo.data2208 WHERE started_at >= ended_at; -- 77
DELETE FROM dbo.data2209 WHERE started_at >= ended_at; -- 72
DELETE FROM dbo.data2210 WHERE started_at >= ended_at; -- 65
DELETE FROM dbo.data2211 WHERE started_at >= ended_at; -- 58
DELETE FROM dbo.data2212 WHERE started_at >= ended_at; -- 14



----> Clean 3 : Start_station_id and start_station_name
--Dealing with start_station_id that have multiple start_station_name
-- Data that does contain id referring to multiple names = data2201, data2203, data2204
--! For data2202, there is one id with 2 names --> id: '444' = 'N Shore Channel Trail & Argyle Ave' and 'N Shore Channel Trail & Argyle St'
--! When combined all three presumably cleaned data, there is one id referring to two names - id: '444'. 
--! After looking into the data, the station_name for start_station_id '444' is different in data2201;
--# Clean station_id : 444
UPDATE dbo.data2201 SET start_station_name = 'N Shore Channel Trail & Argyle St' WHERE start_station_id = '444';
UPDATE dbo.data2202 SET start_station_name = 'N Shore Channel Trail & Argyle St' WHERE start_station_id = '444';
--! After updating the data, combined data from 01-04, there are no id referring to multiple nmaes
--# We will use this combined table as reference
--start by December as it has the least number of ids having 2 names
--data2212
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2212 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2212.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2212.start_station_id IN (SELECT start_station_id FROM dbo.data2212 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2212),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2212 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2212.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2212.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);

--data 2211
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2211 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2211.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2211.start_station_id IN (SELECT start_station_id FROM dbo.data2211 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2211),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2211 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2211.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2211.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);


--data 2211
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2211 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2211.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2211.start_station_id IN (SELECT start_station_id FROM dbo.data2211 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2211),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2211 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2211.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2211.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);



--data 2210
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2210 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2210.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2210.start_station_id IN (SELECT start_station_id FROM dbo.data2210 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2210),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2210 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2210.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2210.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);



--data 2209
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2209 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2209.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2209.start_station_id IN (SELECT start_station_id FROM dbo.data2209 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2209),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2209 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2209.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2209.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
-- some data does not have referenced in the initial combined data
UPDATE dbo.data2209
SET start_station_name = REPLACE(start_station_name, 'Public Rack - ', '')
WHERE start_station_id IN ('839', '617', '686', '737', '763', '794', '812', '826', '834');
-- start_station_id '686'
UPDATE dbo.data2209
SET start_station_name = 'Kedzie & 103rd St - West'
WHERE start_station_id = '686';



--data 2208
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2208 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2208.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2208.start_station_id IN (SELECT start_station_id FROM dbo.data2208 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2208),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2208 
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2208.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2208.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);

--2 names: DIVVY 001 - Warehouse test station
UPDATE dbo.data2208
SET start_station_name = 'WestChi'
WHERE start_station_id = 'DIVVY 001 - Warehouse test station';



--data 2207
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2208
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2207
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2207.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2207.start_station_id IN (SELECT start_station_id FROM dbo.data2207 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2208
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2207),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2207
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2207.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2207.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);



--data 2206
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2207
UNION
SELECT * FROM data2208
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2206
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2206.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2206.start_station_id IN (SELECT start_station_id FROM dbo.data2206 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2207
UNION
SELECT * FROM data2208
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2206),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2206
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2206.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2206.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);



--data 2205
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2206
UNION
SELECT * FROM data2207
UNION
SELECT * FROM data2208
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2205
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2205.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2205.start_station_id IN (SELECT start_station_id FROM dbo.data2205 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);
--after cleaning some and combining all, we realize that some data actually have different name between initial data and newly combined data
--Therefore we do another cleaning
WITH combined AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2206
UNION
SELECT * FROM data2207
UNION
SELECT * FROM data2208
UNION
SELECT * FROM data2209
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
),
combined_all AS
(SELECT * FROM combined UNION SELECT * FROM data2205),
distinctstart_station AS
(SELECT DISTINCT start_station_id, start_station_name FROM combined)
UPDATE dbo.data2205
SET start_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2205.start_station_id = ds.start_station_id), start_station_name)
WHERE dbo.data2205.start_station_id IN (SELECT start_station_id FROM combined_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1);



--Let's work with start_station_id now
--Some name has 2 ids. 
-- Let's start with data2201, it is assumed to be clean since it does not have name with 2 ids. However, when combined with the other preassumed-cleaned data, there is incosistency
-- For start_station_name : 'Lakefront Trail & Bryn Mawr Ave'. The id in data2201: 'KA1504000152' while the rest use : '15576'
UPDATE dbo.data2201
SET start_station_id = '15576'
WHERE start_station_name = 'Lakefront Trail & Bryn Mawr Ave';

--In data2202, there are 2 ids for 'Lakefront Trail & Bryn Mawr Ave' :: 'KA1504000152' and '15576'
UPDATE dbo.data2202
SET start_station_id = '15576'
WHERE start_station_name = 'Lakefront Trail & Bryn Mawr Ave' AND start_station_id <> '15576';

--data2205, there are 2 names having 2 ids.
-- One is 'Lake Park Ave & 47th St' :: '812', 'TA1308000035'. We will update all to be 'TA1308000035' following the precleaned data (01-04, 10-12)
UPDATE dbo.data2205
SET start_station_id = 'TA1308000035'
WHERE start_station_name = 'Lake Park Ave & 47th St' AND start_station_id <> 'TA1308000035';
--The other is 'Prairie Ave & Garfield Blvd' :: '906', 'TA1307000160'. We will update all to be 'TA1307000160' following the precleaned data (01-04, 10-12)
UPDATE dbo.data2205
SET start_station_id = 'TA1307000160'
WHERE start_station_name = 'Prairie Ave & Garfield Blvd' AND start_station_id <> 'TA1307000160';

--data2206, there are 6 names with 2 ids.
WITH doubled AS 
(
SELECT start_station_name FROM dbo.data2206 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1
),
combined AS
(
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2201
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2202
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2203
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2204
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2205
)
UPDATE dbo.data2206
SET start_station_id = (SELECT start_station_id FROM combined WHERE dbo.data2206.start_station_name = combined.start_station_name)
WHERE start_station_name IN (SELECT * FROM doubled);


--data2207, there are 4 names with 2 ids.
WITH doubled AS 
(
SELECT start_station_name FROM dbo.data2207 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1
),
combined AS
(
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2201
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2202
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2203
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2204
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2205
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2206
)
UPDATE dbo.data2207
SET start_station_id = (SELECT start_station_id FROM combined WHERE dbo.data2207.start_station_name = combined.start_station_name)
WHERE start_station_name IN (SELECT * FROM doubled);

--data2208; there are 2 ids
WITH doubled AS 
(
SELECT start_station_name FROM dbo.data2208 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1
),
combined AS
(
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2201
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2202
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2203
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2204
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2205
UNION
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2206
)
UPDATE dbo.data2208
SET start_station_id = (SELECT start_station_id FROM combined WHERE dbo.data2208.start_station_name = combined.start_station_name)
WHERE start_station_name IN (SELECT * FROM doubled);

-- data2209; there is one name with 2 ids assigned
UPDATE dbo.data2209
SET start_station_id = 'TA1308000035'
WHERE start_station_name = 'Lake Park Ave & 47th St' AND start_station_id <> 'TA1308000035';


--There are still NULL in start_station_id and start_station_name. Before taking care of it, end_station_name and end_station_id non-null values should be cleaned first

--END_STATION
-- On dbo.data2204 to 12, there are id with multiple names. We should clean that. We will use start_station as our ground for cleaning. 
--To make it faster, we will create a table to filter only distinct start_station_name and id
CREATE TABLE distinctstart_station (
	start_station_id nvarchar(MAX),
	start_station_name nvarchar(MAX)
);
INSERT INTO distinctstart_station
SELECT DISTINCT start_station_id, start_station_name FROM dbo.all_combined WHERE start_station_id IS NOT NULL;

--We will use start_station as reference to clean the end_station
--data2204
UPDATE dbo.data2204
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2204.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2204.end_station_id IN (SELECT end_station_id FROM dbo.data2204 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2205
UPDATE dbo.data2205
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2205.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2205.end_station_id IN (SELECT end_station_id FROM dbo.data2205 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2206
UPDATE dbo.data2206
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2206.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2206.end_station_id IN (SELECT end_station_id FROM dbo.data2206 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2207
UPDATE dbo.data2207
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2207.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2207.end_station_id IN (SELECT end_station_id FROM dbo.data2207 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2208
UPDATE dbo.data2208
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2208.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2208.end_station_id IN (SELECT end_station_id FROM dbo.data2208 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2209
UPDATE dbo.data2209
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2209.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2209.end_station_id IN (SELECT end_station_id FROM dbo.data2209 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2210
UPDATE dbo.data2210
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2210.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2210.end_station_id IN (SELECT end_station_id FROM dbo.data2210 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2211
UPDATE dbo.data2211
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2211.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2211.end_station_id IN (SELECT end_station_id FROM dbo.data2211 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);

--data2212
UPDATE dbo.data2212
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2212.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2212.end_station_id IN (SELECT end_station_id FROM dbo.data2212 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1);


--check data
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.all_combined GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
--There are data with different name accross all data

--create temp table
CREATE TABLE uncleaned_endstation (
	end_station_id nvarchar(MAX)
);
INSERT INTO uncleaned_endstation
SELECT end_station_id FROM dbo.all_combined GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1;

--data2201
UPDATE dbo.data2201
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2201.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2201.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2202
UPDATE dbo.data2202
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2202.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2202.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2203
UPDATE dbo.data2203
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2203.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2203.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2204
UPDATE dbo.data2204
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2204.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2204.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2205
UPDATE dbo.data2205
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2205.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2205.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2206
UPDATE dbo.data2206
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2206.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2206.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2207
UPDATE dbo.data2207
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2207.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2207.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2208
UPDATE dbo.data2208
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2208.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2208.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2209
UPDATE dbo.data2209
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2209.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2209.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2210
UPDATE dbo.data2210
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2210.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2210.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2211
UPDATE dbo.data2211
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2211.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2211.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--data2212
UPDATE dbo.data2212
SET end_station_name = COALESCE((SELECT start_station_name FROM distinctstart_station AS ds WHERE dbo.data2212.end_station_id = ds.start_station_id), end_station_name)
WHERE dbo.data2212.end_station_id IN (SELECT end_station_id FROM uncleaned_endstation);

--delete the temp table
DROP TABLE uncleaned_endstation;

-- Update for data end_station_id IN ('731') which is only data2208 and data2210
UPDATE dbo.data2210
SET end_station_name = 'Paul Revere Elementary School'
WHERE end_station_id = '731';

--Update end_station_id IN ('812'), we changed all 812 into TA1308000035 on start_station
--data2205
UPDATE dbo.data2205
SET end_station_id = 'TA1308000035'
WHERE end_station_id = '812';

--data2206
UPDATE dbo.data2206
SET end_station_id = 'TA1308000035'
WHERE end_station_id = '812';

--data2207
UPDATE dbo.data2207
SET end_station_id = 'TA1308000035'
WHERE end_station_id = '812';

--data2208
UPDATE dbo.data2208
SET end_station_id = 'TA1308000035'
WHERE end_station_id = '812';

--data2209
UPDATE dbo.data2209
SET end_station_id = 'TA1308000035'
WHERE end_station_id = '812';

--data2211
UPDATE dbo.data2211
SET end_station_id = 'TA1308000035'
WHERE end_station_id = '812';

--data2212
UPDATE dbo.data2212
SET end_station_id = 'TA1308000035'
WHERE end_station_id = '812';

--name with multiple ids inside end_station data
--data2202
UPDATE dbo.data2202
SET end_station_id = (SELECT start_station_id FROM dbo.distinctstart_station AS combined WHERE dbo.data2202.end_station_name = combined.start_station_name)
WHERE end_station_name IN ('Lakefront Trail & Bryn Mawr Ave');

--data2205
UPDATE dbo.data2205
SET end_station_id = (SELECT start_station_id FROM dbo.distinctstart_station AS combined WHERE dbo.data2205.end_station_name = combined.start_station_name)
WHERE end_station_name IN ('Prairie Ave & Garfield Blvd');

--data2206
UPDATE dbo.data2206
SET end_station_id = (SELECT start_station_id FROM dbo.distinctstart_station AS combined WHERE dbo.data2206.end_station_name = combined.start_station_name)
WHERE end_station_name IN ('Bradley Park', 'Calumet Ave & 71st St', 'Eggleston Ave & 92nd St', 'Lawndale Ave & 111th St', 'Prairie Ave & Garfield Blvd');

--data2207
UPDATE dbo.data2207
SET end_station_id = (SELECT start_station_id FROM dbo.distinctstart_station AS combined WHERE dbo.data2207.end_station_name = combined.start_station_name)
WHERE end_station_name IN ('Calumet Ave & 71st St', 'Eggleston Ave & 92nd St', 'Lawndale Ave & 111th St', 'Prairie Ave & Garfield Blvd');

--data2208
UPDATE dbo.data2208
SET end_station_id = (SELECT start_station_id FROM dbo.distinctstart_station AS combined WHERE dbo.data2208.end_station_name = combined.start_station_name)
WHERE end_station_name IN ('Lawndale Ave & 111th St', 'Prairie Ave & Garfield Blvd');

--data2201
UPDATE dbo.data2201
SET end_station_id = (SELECT start_station_id FROM dbo.distinctstart_station AS combined WHERE dbo.data2201.end_station_name = combined.start_station_name)
WHERE end_station_id = 'KA1504000152';


UPDATE dbo.data2201
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2201.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2202
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2202.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2203
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2203.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2204
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2204.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2205
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2205.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2206
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2206.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2207
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2207.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2208
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2208.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2209
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2209.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2210
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2210.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2211
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2211.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');

UPDATE dbo.data2212
SET end_station_name = (SELECT start_station_name FROM dbo.distinctstart_station AS combined WHERE dbo.data2212.end_station_id = combined.start_station_id)
WHERE end_station_id IN ('615', '629', '727', '790', '912');


--fill null start_station with data from another

CREATE TABLE fill_station (
	start_station_id nvarchar(MAX),
	start_station_name nvarchar(MAX),
	start_lat decimal(18, 14),
	start_lng decimal(18, 14)
);

INSERT INTO fill_station
select * from dbo.fill_station_coords;

select a.ride_id, a.start_lat, a.start_lng, f.start_station_id, f.start_station_name FROM dbo.all_combined AS a LEFT JOIN fill_station AS f ON a.start_lat = f.start_lat AND a.start_lng = f.start_lng WHERE a.start_station_id IS NULL;


-- Fill NULL start_station_id and start_station_name using lat and lng
UPDATE dbo.data2201
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2201.start_lat = fs.start_lat AND dbo.data2201.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2201.start_lat = fs.start_lat AND dbo.data2201.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;

SELECT COUNT(*) FROM dbo.data2202 WHERE start_station_id IS NULL; --18580
UPDATE dbo.data2202
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2202.start_lat = fs.start_lat AND dbo.data2202.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2202.start_lat = fs.start_lat AND dbo.data2202.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2202 WHERE start_station_id IS NULL; --14159


SELECT COUNT(*) FROM dbo.data2203 WHERE start_station_id IS NULL; --47246
UPDATE dbo.data2203
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2203.start_lat = fs.start_lat AND dbo.data2203.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2203.start_lat = fs.start_lat AND dbo.data2203.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2203 WHERE start_station_id IS NULL; --36252

SELECT COUNT(*) FROM dbo.data2204 WHERE start_station_id IS NULL; --70886
UPDATE dbo.data2204
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2204.start_lat = fs.start_lat AND dbo.data2204.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2204.start_lat = fs.start_lat AND dbo.data2204.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2204 WHERE start_station_id IS NULL; --55582

SELECT COUNT(*) FROM dbo.data2205 WHERE start_station_id IS NULL; --86704
UPDATE dbo.data2205
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2205.start_lat = fs.start_lat AND dbo.data2205.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2205.start_lat = fs.start_lat AND dbo.data2205.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2205 WHERE start_station_id IS NULL; --67145


SELECT COUNT(*) FROM dbo.data2206 WHERE start_station_id IS NULL; --92935
UPDATE dbo.data2206
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2206.start_lat = fs.start_lat AND dbo.data2206.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2206.start_lat = fs.start_lat AND dbo.data2206.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2206 WHERE start_station_id IS NULL; --71562


SELECT COUNT(*) FROM dbo.data2207 WHERE start_station_id IS NULL; --112028
UPDATE dbo.data2207
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2207.start_lat = fs.start_lat AND dbo.data2207.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2207.start_lat = fs.start_lat AND dbo.data2207.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2207 WHERE start_station_id IS NULL; --86481


SELECT COUNT(*) FROM dbo.data2208 WHERE start_station_id IS NULL; --112034
UPDATE dbo.data2208
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2208.start_lat = fs.start_lat AND dbo.data2208.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2208.start_lat = fs.start_lat AND dbo.data2208.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2208 WHERE start_station_id IS NULL; --86570


SELECT COUNT(*) FROM dbo.data2209 WHERE start_station_id IS NULL; --103777
UPDATE dbo.data2209
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2209.start_lat = fs.start_lat AND dbo.data2209.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2209.start_lat = fs.start_lat AND dbo.data2209.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2209 WHERE start_station_id IS NULL; --79201



SELECT COUNT(*) FROM dbo.data2210 WHERE start_station_id IS NULL; --91353
UPDATE dbo.data2210
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2210.start_lat = fs.start_lat AND dbo.data2210.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2210.start_lat = fs.start_lat AND dbo.data2210.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2210 WHERE start_station_id IS NULL; --69064


SELECT COUNT(*) FROM dbo.data2211 WHERE start_station_id IS NULL; --51952
UPDATE dbo.data2211
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2211.start_lat = fs.start_lat AND dbo.data2211.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2211.start_lat = fs.start_lat AND dbo.data2211.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2211 WHERE start_station_id IS NULL; --39291


SELECT COUNT(*) FROM dbo.data2212 WHERE start_station_id IS NULL; --29283
UPDATE dbo.data2212
SET start_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2212.start_lat = fs.start_lat AND dbo.data2212.start_lng = fs.start_lng),
start_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2212.start_lat = fs.start_lat AND dbo.data2212.start_lng = fs.start_lng)
WHERE start_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2212 WHERE start_station_id IS NULL; --22065


-- Fill NULL end_station_id and end_station_name using lat and lng
SELECT COUNT(*) FROM dbo.data2201 WHERE end_station_id IS NULL; --17836
UPDATE dbo.data2201
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2201.end_lat = fs.start_lat AND dbo.data2201.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2201.end_lat = fs.start_lat AND dbo.data2201.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2201 WHERE end_station_id IS NULL; --13565


SELECT COUNT(*) FROM dbo.data2202 WHERE end_station_id IS NULL; --20277
UPDATE dbo.data2202
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2202.end_lat = fs.start_lat AND dbo.data2202.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2202.end_lat = fs.start_lat AND dbo.data2202.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2202 WHERE end_station_id IS NULL; --15447


SELECT COUNT(*) FROM dbo.data2203 WHERE end_station_id IS NULL; --50885
UPDATE dbo.data2203
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2203.end_lat = fs.start_lat AND dbo.data2203.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2203.end_lat = fs.start_lat AND dbo.data2203.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2203 WHERE end_station_id IS NULL; --39247

SELECT COUNT(*) FROM dbo.data2204 WHERE end_station_id IS NULL; --74954
UPDATE dbo.data2204
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2204.end_lat = fs.start_lat AND dbo.data2204.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2204.end_lat = fs.start_lat AND dbo.data2204.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2204 WHERE end_station_id IS NULL; --58777

SELECT COUNT(*) FROM dbo.data2205 WHERE end_station_id IS NULL; --92430
UPDATE dbo.data2205
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2205.end_lat = fs.start_lat AND dbo.data2205.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2205.end_lat = fs.start_lat AND dbo.data2205.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2205 WHERE end_station_id IS NULL; --71834


SELECT COUNT(*) FROM dbo.data2206 WHERE end_station_id IS NULL; --99074
UPDATE dbo.data2206
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2206.end_lat = fs.start_lat AND dbo.data2206.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2206.end_lat = fs.start_lat AND dbo.data2206.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2206 WHERE end_station_id IS NULL; --76588


SELECT COUNT(*) FROM dbo.data2207 WHERE end_station_id IS NULL; --119986
UPDATE dbo.data2207
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2207.end_lat = fs.start_lat AND dbo.data2207.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2207.end_lat = fs.start_lat AND dbo.data2207.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2207 WHERE end_station_id IS NULL; --93045


SELECT COUNT(*) FROM dbo.data2208 WHERE end_station_id IS NULL; --119655
UPDATE dbo.data2208
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2208.end_lat = fs.start_lat AND dbo.data2208.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2208.end_lat = fs.start_lat AND dbo.data2208.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2208 WHERE end_station_id IS NULL; --93037


SELECT COUNT(*) FROM dbo.data2209 WHERE end_station_id IS NULL; --110430
UPDATE dbo.data2209
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2209.end_lat = fs.start_lat AND dbo.data2209.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2209.end_lat = fs.start_lat AND dbo.data2209.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2209 WHERE end_station_id IS NULL; --84637



SELECT COUNT(*) FROM dbo.data2210 WHERE end_station_id IS NULL; --96109
UPDATE dbo.data2210
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2210.end_lat = fs.start_lat AND dbo.data2210.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2210.end_lat = fs.start_lat AND dbo.data2210.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2210 WHERE end_station_id IS NULL; --73007


SELECT COUNT(*) FROM dbo.data2211 WHERE end_station_id IS NULL; --54016
UPDATE dbo.data2211
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2211.end_lat = fs.start_lat AND dbo.data2211.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2211.end_lat = fs.start_lat AND dbo.data2211.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2211 WHERE end_station_id IS NULL; --41090


SELECT COUNT(*) FROM dbo.data2212 WHERE end_station_id IS NULL; --31026
UPDATE dbo.data2212
SET end_station_id = (SELECT start_station_id FROM dbo.fill_station AS fs WHERE dbo.data2212.end_lat = fs.start_lat AND dbo.data2212.end_lng = fs.start_lng),
end_station_name = (SELECT start_station_name FROM dbo.fill_station AS fs WHERE dbo.data2212.end_lat = fs.start_lat AND dbo.data2212.end_lng = fs.start_lng)
WHERE end_station_id IS NULL;
SELECT COUNT(*) FROM dbo.data2212 WHERE end_station_id IS NULL; --23510


--Check how many NULL left. Those will be deleted.
SELECT COUNT(*) FROM dbo.data2201; --103679
SELECT COUNT(*) FROM dbo.data2202; --115527
SELECT COUNT(*) FROM dbo.data2203; --283758
SELECT COUNT(*) FROM dbo.data2204; --370901
SELECT COUNT(*) FROM dbo.data2205; --634088
SELECT COUNT(*) FROM dbo.data2206; --768083
SELECT COUNT(*) FROM dbo.data2207; --822469
SELECT COUNT(*) FROM dbo.data2208; --785012
SELECT COUNT(*) FROM dbo.data2209; --700555
SELECT COUNT(*) FROM dbo.data2210; --558145
SELECT COUNT(*) FROM dbo.data2211; --337447
SELECT COUNT(*) FROM dbo.data2212; --181664

SELECT COUNT(*) FROM dbo.data2201 WHERE start_station_id IS NULL or end_station_id IS NULL; --19197
SELECT COUNT(*) FROM dbo.data2202 WHERE start_station_id IS NULL or end_station_id IS NULL; --21666
SELECT COUNT(*) FROM dbo.data2203 WHERE start_station_id IS NULL or end_station_id IS NULL; --55930
SELECT COUNT(*) FROM dbo.data2204 WHERE start_station_id IS NULL or end_station_id IS NULL; --82400
SELECT COUNT(*) FROM dbo.data2205 WHERE start_station_id IS NULL or end_station_id IS NULL; --108109
SELECT COUNT(*) FROM dbo.data2206 WHERE start_station_id IS NULL or end_station_id IS NULL; --120107
SELECT COUNT(*) FROM dbo.data2207 WHERE start_station_id IS NULL or end_station_id IS NULL; --146147
SELECT COUNT(*) FROM dbo.data2208 WHERE start_station_id IS NULL or end_station_id IS NULL; --146151
SELECT COUNT(*) FROM dbo.data2209 WHERE start_station_id IS NULL or end_station_id IS NULL; --133177
SELECT COUNT(*) FROM dbo.data2210 WHERE start_station_id IS NULL or end_station_id IS NULL; --114991
SELECT COUNT(*) FROM dbo.data2211 WHERE start_station_id IS NULL or end_station_id IS NULL; --65237
SELECT COUNT(*) FROM dbo.data2212 WHERE start_station_id IS NULL or end_station_id IS NULL; --36685

DELETE FROM dbo.data2201 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --19197
DELETE FROM dbo.data2202 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --21666
DELETE FROM dbo.data2203 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --55930
DELETE FROM dbo.data2204 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --82400
DELETE FROM dbo.data2205 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --108109
DELETE FROM dbo.data2206 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --120107
DELETE FROM dbo.data2207 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --146147
DELETE FROM dbo.data2208 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --146151
DELETE FROM dbo.data2209 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --133177
DELETE FROM dbo.data2210 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --114991
DELETE FROM dbo.data2211 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --65237
DELETE FROM dbo.data2212 WHERE (start_station_id IS NULL) OR (end_station_id IS NULL); --36685


SELECT COUNT(*) FROM dbo.data2201; --84482
SELECT COUNT(*) FROM dbo.data2202; --93861
SELECT COUNT(*) FROM dbo.data2203; --227828
SELECT COUNT(*) FROM dbo.data2204; --288501
SELECT COUNT(*) FROM dbo.data2205; --525979
SELECT COUNT(*) FROM dbo.data2206; --647976
SELECT COUNT(*) FROM dbo.data2207; --676322
SELECT COUNT(*) FROM dbo.data2208; --638861
SELECT COUNT(*) FROM dbo.data2209; --567378
SELECT COUNT(*) FROM dbo.data2210; --443154
SELECT COUNT(*) FROM dbo.data2211; --272210
SELECT COUNT(*) FROM dbo.data2212; --144979


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
--