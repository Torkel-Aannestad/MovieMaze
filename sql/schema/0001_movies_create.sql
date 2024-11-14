-- +goose Up
CREATE TABLE IF NOT EXISTS movies (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,  
    created_at timestamp(0) with time zone NOT NULL DEFAULT NOW(),
    title text NOT NULL,
    year integer NOT NULL,
    runtime integer NOT NULL,
    genres text[] NOT NULL,
    version integer NOT NULL DEFAULT 1
);

-- +goose Down
DROP TABLE IF EXISTS movies;
