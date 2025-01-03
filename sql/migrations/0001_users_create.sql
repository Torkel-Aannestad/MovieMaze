-- +goose Up
CREATE TABLE IF NOT EXISTS users (
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,  
    created_at timestamp(0) with time zone NOT NULL DEFAULT NOW(),
    name text NOT NULL,
    email citext UNIQUE NOT NULL,
    password_hash text NOT NULL,
    activated bool NOT NULL,
    version integer NOT NULL DEFAULT 1
);

-- +goose Down
DROP TABLE IF EXISTS users;