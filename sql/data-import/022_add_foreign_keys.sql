BEGIN;

\echo ''
\echo '022_add_foreign_keys'

-- movie references
ALTER TABLE movies             ADD FOREIGN KEY (parent_id) REFERENCES movies (id) ON DELETE cascade,
                               ADD FOREIGN KEY (series_id) REFERENCES movies (id) ON DELETE cascade;
ALTER TABLE people_links       ADD FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE cascade;
ALTER TABLE casts              ADD FOREIGN KEY (movie_id) REFERENCES movies (id) ON DELETE cascade,
                               ADD FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE cascade,
                               ADD FOREIGN KEY (job_id) REFERENCES jobs (id) ON DELETE cascade;
ALTER TABLE movie_categories   ADD FOREIGN KEY (movie_id) REFERENCES movies (id) ON DELETE cascade,
                               ADD FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE cascade;
ALTER TABLE movie_keywords     ADD FOREIGN KEY (movie_id) REFERENCES movies (id) ON DELETE cascade,
                               ADD FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE cascade;
ALTER TABLE trailers           ADD FOREIGN KEY (movie_id) REFERENCES movies (id) ON DELETE cascade;
ALTER TABLE movie_links        ADD FOREIGN KEY (movie_id) REFERENCES movies (id) ON DELETE cascade;

-- other references
ALTER TABLE image_licenses     ADD FOREIGN KEY (image_id) REFERENCES image_ids (id) ON DELETE cascade;
ALTER TABLE categories         ADD FOREIGN KEY (parent_id) REFERENCES categories (id) ON DELETE cascade,
                               ADD FOREIGN KEY (root_id) REFERENCES categories (id) ON DELETE cascade;

-- ALTER TABLE movie_references   ADD FOREIGN KEY (movie_id) REFERENCES movies (id) ON DELETE cascade,
--                                ADD FOREIGN KEY (referenced_id) REFERENCES movies (id) ON DELETE cascade;
COMMIT;
