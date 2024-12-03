package main

import (
	"errors"
	"fmt"
	"time"

	"net/http"

	"github.com/Torkel-Aannestad/MovieMaze/internal/database"
	"github.com/Torkel-Aannestad/MovieMaze/internal/validator"
)

func (app *application) createCastHandler(w http.ResponseWriter, r *http.Request) {
	var input struct {
		MovieID  int64   `json:"movie_id"`
		PersonID int64   `json:"person_id"`
		JobID    int64   `json:"job_id"`
		Role     *string `json:"role"`
		Position int32   `json:"position"`
	}

	err := app.readJSON(w, r, &input)
	if err != nil {
		app.badRequestResponse(w, r, err)
		return
	}

	cast := database.Cast{
		MovieID:  input.MovieID,
		PersonID: input.PersonID,
		JobID:    input.JobID,
		Position: input.Position,
	}

	v := validator.New()
	if input.Role != nil {
		cast.Role = *input.Role
	} else {
		v.AddError("role", "role must be provided")
		app.failedValidationResponse(w, r, v.Errors)
		return
	}

	database.ValidateCast(v, &cast)
	if !v.Valid() {
		app.failedValidationResponse(w, r, v.Errors)
		return
	}

	err = app.models.Casts.Insert(&cast)
	if err != nil {
		app.serverErrorResponse(w, r, err)
		return
	}

	header := make(http.Header)
	header.Set("Location", fmt.Sprintf("/v1/movies/%d", cast.MovieID))

	err = app.writeJSON(w, http.StatusCreated, envelope{"casts": cast}, header)
	if err != nil {
		app.serverErrorResponse(w, r, err)
		return
	}

}
func (app *application) getCastHandler(w http.ResponseWriter, r *http.Request) {
	id, err := app.readIDParam(r)
	if err != nil {
		app.notFoundResponse(w, r)
		return
	}

	person, err := app.models.People.Get(id)
	if err != nil {
		if errors.Is(err, database.ErrRecordNotFound) {
			app.notFoundResponse(w, r)

		} else {
			app.serverErrorResponse(w, r, err)
		}
		return
	}

	err = app.writeJSON(w, http.StatusOK, envelope{"person": person}, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
		return
	}
}

func (app *application) listCastsHandler(w http.ResponseWriter, r *http.Request) {
	var input struct {
		Name string
		database.Filters
	}

	qs := r.URL.Query()

	v := validator.New()

	input.Name = app.readString(qs, "name", "")
	input.Filters.Page = app.readInt(qs, "page", 1, v)
	input.Filters.PageSize = app.readInt(qs, "page_size", 20, v)
	input.Filters.Sort = app.readString(qs, "sort", "id")
	input.Filters.SortSafelist = []string{"id", "name", "birthday", "-id", "-name", "-birthday"}

	database.ValidateFilters(v, input.Filters)
	if !v.Valid() {
		app.failedValidationResponse(w, r, v.Errors)
		return
	}

	people, metadata, err := app.models.People.GetAll(input.Name, input.Filters)
	if err != nil {
		app.serverErrorResponse(w, r, err)
		return
	}

	err = app.writeJSON(w, http.StatusOK, envelope{"people": people, "metadata": metadata}, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}

func (app *application) updateCastHandler(w http.ResponseWriter, r *http.Request) {
	id, err := app.readIDParam(r)
	if err != nil {
		app.notFoundResponse(w, r)
		return
	}

	var input struct {
		Name     *string    `json:"name"`
		Birthday *time.Time `json:"birthday,omitempty"`
		Deathday *time.Time `json:"deathday,omitempty"`
		Gender   *string    `json:"gender,omitempty"`
		Aliases  *[]string  `json:"aliases,omitempty"`
		Version  *int32     `json:"version"`
	}

	err = app.readJSON(w, r, &input)
	if err != nil {
		app.badRequestResponse(w, r, err)
		return
	}

	person, err := app.models.People.Get(id)
	if err != nil {
		if errors.Is(err, database.ErrRecordNotFound) {
			app.notFoundResponse(w, r)
		} else {
			app.serverErrorResponse(w, r, err)
		}
		return
	}

	if input.Name != nil {
		person.Name = *input.Name
	}
	if input.Birthday != nil {
		person.Birthday = *input.Birthday
	}
	if input.Deathday != nil {
		person.Deathday = *input.Deathday
	}
	if input.Gender != nil {
		person.Gender = *input.Gender
	}
	if input.Aliases != nil {
		person.Aliases = *input.Aliases
	}

	v := validator.New()
	database.ValidatePeople(v, person)
	if !v.Valid() {
		app.failedValidationResponse(w, r, v.Errors)
		return
	}

	err = app.models.People.Update(person)
	if err != nil {
		if errors.Is(err, database.ErrEditConflict) {
			app.editConflictResponse(w, r)
		} else {
			app.serverErrorResponse(w, r, err)
		}
		return
	}

	app.writeJSON(w, http.StatusOK, envelope{"people": person}, nil)

}

func (app *application) deleteCastHandler(w http.ResponseWriter, r *http.Request) {
	id, err := app.readIDParam(r)
	if err != nil {
		app.notFoundResponse(w, r)
		return
	}

	err = app.models.People.Delete(id)
	if err != nil {
		if errors.Is(err, database.ErrRecordNotFound) {
			app.notFoundResponse(w, r)
		} else {
			app.serverErrorResponse(w, r, err)
		}
		return
	}
	err = app.writeJSON(w, http.StatusOK, envelope{"message": "person successfuly deleted"}, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}
