-- ACTOR
SELECT movies.id, movies.title, cast_members.character, actors.name
FROM movies
JOIN cast_members ON movies.id = cast_members.movie_id
JOIN actors ON cast_members.actor_id = actors.id
WHERE actors.id = 21234;


-- MOVIE
SELECT movies.title, movies.year, movies.rating, genres.name, studios.name
FROM movies
JOIN genres ON movies.genre_id = genres.id
JOIN studios ON movies.studio_id = studios.id
WHERE movies.id = 1731;

-- MOVIE DETAILS
SELECT movies.id, movies.title, actors.name AS actor, actors.id AS actor_id, cast_members.character, genres.name AS genre, studios.name AS studio
FROM movies
JOIN cast_members ON movies.id = cast_members.movie_id
JOIN actors ON cast_members.actor_id = actors.id
JOIN genres ON movies.genre_id = genres.id
JOIN studios ON movies.studio_id = studios.id
WHERE movies.id = 3379;
