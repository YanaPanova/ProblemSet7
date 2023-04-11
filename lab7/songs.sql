-- 1.sql
--SQL query to list the names of all songs in the database
SELECT name FROM songs;

-- 2.sql
-- SQL query to list the name of all songs in increasing order of tempo
SELECT name FROM songs ORDER BY tempo;

-- 3.sql
-- SQL query to list the name of the top 5 longest songs, in descending order of length
SELECT name FROM songs ORDER BY duration_ms DESC LIMIT 5;

-- 4.sql
-- SQL query to list the name of the names of any songs that have danceability, energy and valence greater than 0.75
SELECT name FROM songs WHERE danceability > 0.75 AND energy > 0.75 AND valence > 0.75;

-- 5.sql
-- SQL query that returns the average energy of all the songs
SELECT avg(energy) FROM songs;

-- 6.sql
-- SQL query that lists the names of songs that are by Post Malone
SELECT name FROM songs WHERE artist_id = (SELECT id FROM artists WHERE name == "Post Malone");

-- 7.sql
-- SQL query that returns the average energy of songs that are by Drake
SELECT avg(energy) FROM songs WHERE artist_id = (SELECT id FROM artists WHERE name == "Drake");

-- 8.sql
-- SQL query that lists the names of songs that feature other artists
SELECT name FROM songs WHERE name LIKE "%feat.%";
