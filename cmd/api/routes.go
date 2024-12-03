package main

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

func (app *application) routes() http.Handler {

	router := httprouter.New()

	router.NotFound = http.HandlerFunc(app.notFoundResponse)
	router.MethodNotAllowed = http.HandlerFunc(app.methodNotAllowedResponse)

	router.HandlerFunc(http.MethodGet, "/v1/healthcheck", app.healthcheckHandler)
	router.HandlerFunc(http.MethodGet, "/v1/movies", app.protectedRoute("movies:read", app.listMoviesHandler))
	router.HandlerFunc(http.MethodPost, "/v1/movies", app.protectedRoute("movies:write", app.createMovieHandler))
	router.HandlerFunc(http.MethodGet, "/v1/movies/:id", app.protectedRoute("movies:read", app.getMovieHandler))
	router.HandlerFunc(http.MethodPatch, "/v1/movies/:id", app.protectedRoute("movies:write", app.updateMovieHandler))
	router.HandlerFunc(http.MethodDelete, "/v1/movies/:id", app.protectedRoute("movies:write", app.deleteMovieHandler))

	router.HandlerFunc(http.MethodGet, "/v1/people", app.protectedRoute("people:read", app.listPeopleHandler))
	router.HandlerFunc(http.MethodPost, "/v1/people", app.protectedRoute("people:write", app.createPeopleHandler))
	router.HandlerFunc(http.MethodGet, "/v1/people/:id", app.protectedRoute("people:read", app.getPeopleHandler))
	router.HandlerFunc(http.MethodPatch, "/v1/people/:id", app.protectedRoute("people:write", app.updatePeopleHandler))
	router.HandlerFunc(http.MethodDelete, "/v1/people/:id", app.protectedRoute("people:write", app.deletePeopleHandler))

	router.HandlerFunc(http.MethodGet, "/v1/casts/:movie_id", app.protectedRoute("casts:read", app.getCastsByMovieIdHandler))
	router.HandlerFunc(http.MethodGet, "/v1/casts/:person_id", app.protectedRoute("casts:read", app.getCastsByPersonIdHandler))
	router.HandlerFunc(http.MethodPost, "/v1/casts", app.protectedRoute("casts:write", app.createCastHandler))
	router.HandlerFunc(http.MethodDelete, "/v1/casts", app.protectedRoute("casts:write", app.deleteCastHandler))

	router.HandlerFunc(http.MethodPost, "/v1/users", app.registerUserHandler)
	router.HandlerFunc(http.MethodPut, "/v1/users/activated", app.activateUserHandler)

	router.HandlerFunc(http.MethodPost, "/v1/auth/authentication", app.authenticateUserHandler)

	// router.Handler(http.MethodGet, "/metrics", expvar.Handler())

	return app.panicRecovery(app.rateLimit(app.authenticate(router)))
}
