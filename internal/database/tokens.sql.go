// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: tokens.sql

package database

import (
	"context"
	"time"
)

const createToken = `-- name: CreateToken :one
INSERT INTO tokens (hash, user_id, expiry, scope) 
VALUES ($1, $2, $3, $4)
RETURNING hash, user_id, expiry, scope
`

type CreateTokenParams struct {
	Hash   []byte    `json:"hash"`
	UserID int64     `json:"user_id"`
	Expiry time.Time `json:"expiry"`
	Scope  string    `json:"scope"`
}

func (q *Queries) CreateToken(ctx context.Context, arg CreateTokenParams) (Token, error) {
	row := q.db.QueryRowContext(ctx, createToken,
		arg.Hash,
		arg.UserID,
		arg.Expiry,
		arg.Scope,
	)
	var i Token
	err := row.Scan(
		&i.Hash,
		&i.UserID,
		&i.Expiry,
		&i.Scope,
	)
	return i, err
}

const deleteAllForUser = `-- name: DeleteAllForUser :exec
DELETE FROM tokens 
WHERE scope = $1 AND user_id = $2
`

type DeleteAllForUserParams struct {
	Scope  string `json:"scope"`
	UserID int64  `json:"user_id"`
}

func (q *Queries) DeleteAllForUser(ctx context.Context, arg DeleteAllForUserParams) error {
	_, err := q.db.ExecContext(ctx, deleteAllForUser, arg.Scope, arg.UserID)
	return err
}