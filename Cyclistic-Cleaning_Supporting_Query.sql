USE Cyclistic_Raw;
--check id with multiple names
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2201 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2202 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2203 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2204 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2205 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2206 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2207 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2208 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2209 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2210 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2211 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.data2212 GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;

--Out of all, data2201, data2203, data2204 does not have id referring to multiple names
WITH combineddata AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2205
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
)
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM combineddata GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;

select * from data2205 where start_station_id IN ('839', '617', '686', '737', '763', '794', '812', '826', '834')
select DISTINCT start_station_name, start_station_id from data2209 where start_station_id IN ('839', '617', '686', '737', '763', '794', '812', '826', '834') ORDER BY start_station_id;





WITH combineddata AS
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
)
SELECT start_station_id, start_station_name, COUNT(*) AS data_cnt FROM combineddata WHERE start_station_id IN (SELECT start_station_id FROM combineddata GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1) GROUP BY start_station_id, start_station_name ORDER BY start_station_id, data_cnt DESC;




----> name with multiple ids
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2201 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2202 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2203 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2204 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2205 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2206 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2207 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2208 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2209 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2210 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2211 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2212 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;




--but before cleaning those that has 2 ids for the same name, let's make sure the data that does not fall into this category if kept separate is actually clean
WITH tes AS(
SELECT * FROM data2201
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
)
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM tes GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
-- For start_station_name : 'Lakefront Trail & Bryn Mawr Ave'. There are 2 ids: '15576' and 'KA1504000152'
-- Let's see which one has which
SELECT DISTINCT start_station_id, start_station_name FROM data2201 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';
SELECT DISTINCT start_station_id, start_station_name FROM data2203 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';
SELECT DISTINCT start_station_id, start_station_name FROM data2204 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';
SELECT DISTINCT start_station_id, start_station_name FROM data2210 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';
SELECT DISTINCT start_station_id, start_station_name FROM data2211 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';
SELECT DISTINCT start_station_id, start_station_name FROM data2212 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';
--only data2201 use 'KA1504000152'. The rest use '15576'. Therefore we want to keep '15576' as the id



--There is only 1 name with 2 ids for data2202, it is the same one we work previously when combining all preassumed cleaned ones.
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2202 WHERE start_station_name = 'Lakefront Trail & Bryn Mawr Ave';

SELECT DISTINCT start_station_name FROM dbo.data2202 WHERE start_station_id = '15576';
SELECT DISTINCT start_station_name FROM dbo.data2202 WHERE start_station_id = 'KA1504000152';

WITH combineddata AS
(
SELECT * FROM data2201
UNION
SELECT * FROM data2202
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2205
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
)
SELECT DISTINCT start_station_id, start_station_name FROM combineddata WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';


SELECT * FROM data2201 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';
SELECT * FROM data2203 WHERE start_station_id = '15576' OR start_station_id = 'KA1504000152';



--explore data2205
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2205 WHERE start_station_name IN (SELECT start_station_name FROM dbo.data2205 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1) ORDER BY start_station_name;

WITH tes AS(
SELECT * FROM data2201
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
)
SELECT DISTINCT start_station_id, start_station_name FROM tes WHERE start_station_id IN ('812', 'TA1308000035', '906', 'TA1307000160')


--add data2205 and see if it is really cleaned
WITH tes AS(
SELECT * FROM data2201
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2205
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
)
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM tes GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
--Yay! It is clean. We will continue towards data2206

--data2206
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2206 WHERE start_station_name IN (SELECT start_station_name FROM dbo.data2206 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1) ORDER BY start_station_name;

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
select DISTINCT (SELECT start_station_id FROM combined WHERE dbo.data2206.start_station_name = combined.start_station_name) AS id, start_station_name FROM dbo.data2206 WHERE start_station_name IN (SELECT * FROM doubled);

WITH tes AS(
SELECT * FROM data2201
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2205
UNION
SELECT * FROM data2206
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
)
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM tes GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
-- No values returned. Evertyhing seems great

--data2207
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2207 WHERE start_station_name IN (SELECT start_station_name FROM dbo.data2207 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1) ORDER BY start_station_name;

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
select DISTINCT (SELECT start_station_id FROM combined WHERE dbo.data2207.start_station_name = combined.start_station_name) AS id, start_station_name FROM dbo.data2207 WHERE start_station_name IN (SELECT * FROM doubled);

WITH tes AS(
SELECT * FROM data2201
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2205
UNION
SELECT * FROM data2206
UNION
SELECT * FROM data2207
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
)
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM tes GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;


--data2208
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2208 WHERE start_station_name IN (SELECT start_station_name FROM dbo.data2208 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1) ORDER BY start_station_name;

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
select DISTINCT (SELECT start_station_id FROM combined WHERE dbo.data2208.start_station_name = combined.start_station_name) AS id, start_station_name FROM dbo.data2208 WHERE start_station_name IN (SELECT * FROM doubled);


WITH tes AS(
SELECT * FROM data2201
UNION
SELECT * FROM data2203
UNION
SELECT * FROM data2204
UNION
SELECT * FROM data2205
UNION
SELECT * FROM data2206
UNION
SELECT * FROM data2207
UNION
SELECT * FROM data2208
UNION
SELECT * FROM data2210
UNION
SELECT * FROM data2211
UNION
SELECT * FROM data2212
)
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM tes GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;


--data2209
SELECT DISTINCT start_station_id, start_station_name FROM dbo.data2209 WHERE start_station_name IN (SELECT start_station_name FROM dbo.data2209 GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1) ORDER BY start_station_name;

SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.all_combined GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
-- ALL GOOD!!!


--There are still NULL in start_station_id and start_station_name. Before dropping these rows, let's see if we can populate the rows using data from start_lat, start_lng
SELECT COUNT(*) FROM dbo.all_combined WHERE start_station_id IS NULL;

SELECT CONCAT(start_lat, ', ', start_lng) AS start_coords, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2201 WHERE (start_station_id IS NOT NULL) GROUP BY CONCAT(start_lat, ', ', start_lng) HAVING COUNT( DISTINCT start_station_id) > 1 ORDER BY id_count DESC;

select distinct start_station_id, start_station_name FROM data2201 WHERE start_lat = 41.84000000000000 AND start_lng = -87.73000000000000;

SELECT CONCAT(start_lat, ', ', start_lng) AS start_coords, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.data2201 WHERE (start_station_id IS NOT NULL) GROUP BY CONCAT(start_lat, ', ', start_lng) HAVING COUNT( DISTINCT start_station_id) = 1;

select CONCAT(start_lat, ', ', start_lng) AS start_coords, start_station_id, COUNT(*) AS rows_count from dbo.data2201 WHERE CONCAT(start_lat, ', ', start_lng) IN (SELECT CONCAT(start_lat, ', ', start_lng) AS start_coords FROM dbo.data2201 WHERE (start_station_id IS NOT NULL) GROUP BY CONCAT(start_lat, ', ', start_lng) HAVING COUNT( DISTINCT start_station_id) = 1) GROUP BY CONCAT(start_lat, ', ', start_lng), start_station_id ORDER BY rows_count DESC;


select DISTINCT CONCAT(start_lat, ', ', start_lng) AS start_coords, start_station_id, start_station_name from dbo.data2201 WHERE CONCAT(start_lat, ', ', start_lng) IN (SELECT CONCAT(start_lat, ', ', start_lng) AS start_coords FROM dbo.data2201 WHERE (start_station_id IS NOT NULL) GROUP BY CONCAT(start_lat, ', ', start_lng) HAVING COUNT( DISTINCT start_station_id) = 1);



--Try to create a temp table as anchor for this later.
SELECT DISTINCT CONCAT(start_lat, ', ', start_lng) AS start_coords, start_station_id, start_station_name FROM dbo.all_combined WHERE CONCAT(start_lat, ', ', start_lng) IN (SELECT CONCAT(start_lat, ', ', start_lng) AS start_coords FROM dbo.all_combined WHERE (start_station_id IS NOT NULL) GROUP BY CONCAT(start_lat, ', ', start_lng) HAVING COUNT( DISTINCT start_station_id) = 1) AND start_station_id IS NOT NULL;

--Before dropping these rows, let's see if we can populate the rows using data from start_lat, start_lng
-- As it turns out there are lat,lng that has multiple stations, therefore we cannot populate the data as we don't know for sure which is which.
-- We will populate rows in which start_lat and start_lng only has 1 station. We will drop the rest
-- data2201
SELECT COUNT(*) FROM dbo.data2201 WHERE start_station_id IS NULL; --16260
SELECT COUNT(*) FROM dbo.data2201 WHERE start_station_name IS NULL; --16260
SELECT COUNT(start_station_id), COUNT(start_station_name) FROM dbo.data2201; --87419


-----------------------------------------------------------------------------
--check id with multiple names
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2201 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2202 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2203 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2204 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2205 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2206 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2207 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2208 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2209 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2210 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2211 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.data2212 GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;

SELECT end_station_id, COUNT(DISTINCT end_station_name) AS name_count FROM dbo.all_combined GROUP BY end_station_id HAVING COUNT(DISTINCT end_station_name) > 1 ORDER BY name_count DESC;
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM dbo.all_combined GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;




select * from dbo.all_combined WHERE end_station_id = 'TA1308000035' AND end_station_name = 'Public Rack - Lake Park Ave & 47th St';


select * from data2201 where end_station_id IN ('KA1504000152');
select * from data2202 where end_station_id IN ('KA1504000152');
select * from data2203 where end_station_id IN ('KA1504000152');
select * from data2204 where end_station_id IN ('KA1504000152');
select * from data2205 where end_station_id IN ('KA1504000152');
select * from data2206 where end_station_id IN ('KA1504000152');
select * from data2207 where end_station_id IN ('KA1504000152');
select * from data2208 where end_station_id IN ('KA1504000152'); --731
select * from data2209 where end_station_id IN ('KA1504000152');
select * from data2210 where end_station_id IN ('KA1504000152');
select * from data2211 where end_station_id IN ('KA1504000152');
select * from data2212 where end_station_id IN ('KA1504000152');



--name with multiple ids
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2201 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2202 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2203 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2204 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2205 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2206 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2207 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2208 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2209 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2210 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2211 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.data2212 GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;


SELECT end_station_name, COUNT(DISTINCT end_station_id) AS id_count FROM dbo.all_combined GROUP BY end_station_name HAVING COUNT(DISTINCT end_station_id) > 1 ORDER BY id_count DESC;
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM dbo.all_combined GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;

WITH station_all AS
(
SELECT DISTINCT start_station_id, start_station_name FROM dbo.all_combined
UNION
SELECT DISTINCT end_station_id, end_station_name FROM dbo.all_combined
)
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM station_all GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;


WITH station_all AS
(
SELECT DISTINCT start_station_id, start_station_name FROM dbo.all_combined
UNION
SELECT DISTINCT end_station_id, end_station_name FROM dbo.all_combined
)
SELECT start_station_id, COUNT(DISTINCT start_station_name) AS name_count FROM station_all GROUP BY start_station_id HAVING COUNT(DISTINCT start_station_name) > 1 ORDER BY name_count DESC;
--there are some ids with multiple names if we combine start and end station data


WITH station_all AS
(
SELECT DISTINCT start_station_id, start_station_name FROM dbo.all_combined
UNION
SELECT DISTINCT end_station_id, end_station_name FROM dbo.all_combined
)
SELECT start_station_name, COUNT(DISTINCT start_station_id) AS id_count FROM station_all GROUP BY start_station_name HAVING COUNT(DISTINCT start_station_id) > 1 ORDER BY id_count DESC;
-- there are no names with multiple ids if we combine start and end station data

CREATE VIEW fill_station_coords AS
WITH distinct_station_all AS(
SELECT DISTINCT start_lat AS lat, start_lng AS lng, start_station_id AS station_id, start_station_name AS station_name FROM dbo.all_combined WHERE start_station_id IS NOT NULL
UNION
SELECT DISTINCT end_lat, end_lng, end_station_id, end_station_name FROM dbo.all_combined WHERE end_station_id IS NOT NULL
),
unique_station AS(
SELECT lat, lng FROM distinct_station_all GROUP BY lat, lng HAVING COUNT(station_id) = 1
)
SELECT dsa.station_id, dsa.station_name, us.lat, us.lng FROM unique_station AS us INNER JOIN distinct_station_all AS dsa ON us.lat = dsa.lat AND us.lng = dsa.lng;


SELECT COUNT(*) FROM dbo.data2201 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2202 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2203 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2204 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2205 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2206 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2207 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2208 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2209 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2210 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2211 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;
SELECT COUNT(*) FROM dbo.data2212 WHERE start_station_id IS NULL AND start_station_name IS NOT NULL;


SELECT COUNT(*) FROM dbo.data2201 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2202 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2203 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2204 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2205 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2206 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2207 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2208 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2209 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2210 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2211 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;
SELECT COUNT(*) FROM dbo.data2212 WHERE start_station_id IS NOT NULL AND start_station_name IS NULL;


