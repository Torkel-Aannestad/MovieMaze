BEGIN;

CREATE TEMP TABLE IF NOT EXISTS all_movies      (id bigint primary key, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS all_series      (id bigint primary key, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS all_seasons     (id bigint primary key, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS all_episodes    (id bigint primary key, name text, parent_id bigint, date date, series_id bigint);
CREATE TEMP TABLE IF NOT EXISTS all_movieseries (id bigint primary key, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS movie_details (movie_id bigint primary key, runtime int, budget numeric, revenue numeric, homepage text);
CREATE TEMP TABLE IF NOT EXISTS votes (movie_id bigint primary key, vote_average numeric, votes_count bigint);

\copy all_movies            FROM 'sql/data-import/data/all_movies.csv'            WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_series            FROM 'sql/data-import/data/all_series.csv'            WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_seasons           FROM 'sql/data-import/data/all_seasons.csv'           WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_episodes          FROM 'sql/data-import/data/all_episodes.csv'          WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_movieseries       FROM 'sql/data-import/data/all_movieseries.csv'       WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_details         FROM 'sql/data-import/data/movie_details.csv'         WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy votes                 FROM 'sql/data-import/data/all_votes.csv'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')

WITH import_movies AS (
	SELECT id, name, parent_id, date, NULL::bigint AS series_id, 'movie'::kind AS kind FROM all_movies
	UNION ALL
	SELECT id, name, parent_id, date, NULL, 'series' FROM all_series
	UNION ALL
	SELECT id, name, parent_id, date, NULL, 'season' FROM all_seasons
	UNION ALL
	SELECT id, name, parent_id, date, series_id, 'episode' FROM all_episodes
	UNION ALL
	SELECT id, name, parent_id, date, NULL, 'movieseries' FROM all_movieseries
)
INSERT INTO movies
(SELECT id, name, parent_id, date, series_id, kind, -- from import_movies
	runtime, budget, revenue, homepage, -- from movie_details
	vote_average, votes_count -- from votes
FROM import_movies m
	LEFT JOIN movie_details d ON m.id = d.movie_id
	LEFT JOIN votes v ON m.id = v.movie_id);

\copy people                FROM 'sql/data-import/data/all_people.csv'            WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy people_aliases        FROM 'sql/data-import/data/all_people_aliases.csv'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy people_links          FROM 'sql/data-import/data/people_links.csv'          WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy casts                 FROM 'sql/data-import/data/all_casts.csv'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy job_names             FROM 'sql/data-import/data/job_names.csv'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
INSERT INTO jobs SELECT job_id, name FROM job_names WHERE language = 'en';
\copy movie_categories      FROM 'sql/data-import/data/movie_categories.csv'      WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_keywords        FROM 'sql/data-import/data/movie_keywords.csv'        WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy category_names        FROM 'sql/data-import/data/category_names.csv'        WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy categories (id, parent_id, root_id) FROM 'sql/data-import/data/all_categories.csv' WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy trailers              FROM 'sql/data-import/data/trailers.csv'              WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_links           FROM 'sql/data-import/data/movie_links.csv'           WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy image_ids             FROM 'sql/data-import/data/image_ids.csv'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy image_licenses        FROM 'sql/data-import/data/image_licenses.csv'        WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_aliases_iso     FROM 'sql/data-import/data/all_movie_aliases_iso.csv' WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_languages       FROM 'sql/data-import/data/movie_languages.csv'       WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_countries       FROM 'sql/data-import/data/movie_countries.csv'       WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_references      FROM 'sql/data-import/data/movie_references.csv'      WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_de    FROM 'sql/data-import/data/movie_abstracts_de.csv'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_en    FROM 'sql/data-import/data/movie_abstracts_en.csv'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_fr    FROM 'sql/data-import/data/movie_abstracts_fr.csv'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_es    FROM 'sql/data-import/data/movie_abstracts_es.csv'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')

COMMIT;