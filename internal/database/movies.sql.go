// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: movies.sql

package database

import (
	"context"

	"github.com/lib/pq"
)

const createMovie = `-- name: CreateMovie :one
INSERT INTO movies (title, year, runtime, genres) 
VALUES ($1, $2, $3, $4)
RETURNING id, created_at, title, year, runtime, genres, version
`

type CreateMovieParams struct {
	Title   string   `json:"title"`
	Year    int32    `json:"year"`
	Runtime int32    `json:"runtime"`
	Genres  []string `json:"genres"`
}

func (q *Queries) CreateMovie(ctx context.Context, arg CreateMovieParams) (Movie, error) {
	row := q.db.QueryRowContext(ctx, createMovie,
		arg.Title,
		arg.Year,
		arg.Runtime,
		pq.Array(arg.Genres),
	)
	var i Movie
	err := row.Scan(
		&i.ID,
		&i.CreatedAt,
		&i.Title,
		&i.Year,
		&i.Runtime,
		pq.Array(&i.Genres),
		&i.Version,
	)
	return i, err
}
