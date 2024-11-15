// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0

package database

import (
	"time"
)

type Movie struct {
	ID        int64     `json:"id"`
	CreatedAt time.Time `json:"created_at"`
	Title     string    `json:"title"`
	Year      int64     `json:"year"`
	Runtime   int64     `json:"runtime"`
	Genres    []string  `json:"genres"`
	Version   int64     `json:"version"`
}
