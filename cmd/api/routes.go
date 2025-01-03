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

	router.HandlerFunc(http.MethodPost, "/v1/casts", app.protectedRoute("casts:write", app.createCastHandler))
	router.HandlerFunc(http.MethodGet, "/v1/casts/by-movie-id/:id", app.protectedRoute("casts:read", app.getCastsByMovieIdHandler))
	router.HandlerFunc(http.MethodGet, "/v1/casts/by-person-id/:id", app.protectedRoute("casts:read", app.getCastsByPersonIdHandler))
	router.HandlerFunc(http.MethodPatch, "/v1/casts/:id", app.protectedRoute("casts:write", app.updateCastHandler))
	router.HandlerFunc(http.MethodDelete, "/v1/casts/:id", app.protectedRoute("casts:write", app.deleteCastHandler))

	router.HandlerFunc(http.MethodPost, "/v1/jobs", app.protectedRoute("jobs:write", app.createJobHandler))
	router.HandlerFunc(http.MethodGet, "/v1/jobs/:id", app.protectedRoute("jobs:read", app.getJobHandler))
	router.HandlerFunc(http.MethodPatch, "/v1/jobs/:id", app.protectedRoute("jobs:write", app.updateJobHandler))
	router.HandlerFunc(http.MethodDelete, "/v1/jobs/:id", app.protectedRoute("jobs:write", app.deleteJobHandler))

	router.HandlerFunc(http.MethodPost, "/v1/categories", app.protectedRoute("categories:write", app.createCategoryHandler))
	router.HandlerFunc(http.MethodGet, "/v1/categories/:id", app.protectedRoute("categories:read", app.getCategoryHandler))
	router.HandlerFunc(http.MethodPatch, "/v1/categories/:id", app.protectedRoute("categories:write", app.updateCategoryHandler))
	router.HandlerFunc(http.MethodDelete, "/v1/categories/:id", app.protectedRoute("categories:write", app.deleteCategoryHandler))

	router.HandlerFunc(http.MethodPost, "/v1/movie-keywords", app.protectedRoute("category-items:write", app.createMovieKeywordsHandler))
	router.HandlerFunc(http.MethodGet, "/v1/movie-keywords/:id", app.protectedRoute("category-items:read", app.getMovieKeywordsHandler)) //expects movieId
	router.HandlerFunc(http.MethodDelete, "/v1/movie-keywords", app.protectedRoute("category-items:write", app.deleteMovieKeywordHandler))
	router.HandlerFunc(http.MethodPost, "/v1/movie-categories", app.protectedRoute("category-items:write", app.createMovieCategoriesHandler))
	router.HandlerFunc(http.MethodGet, "/v1/movie-categories/:id", app.protectedRoute("category-items:read", app.getMovieCategoriesHandler)) //expects movieId
	router.HandlerFunc(http.MethodDelete, "/v1/movie-categories", app.protectedRoute("category-items:write", app.deleteMovieCategoryHandler))

	router.HandlerFunc(http.MethodPost, "/v1/movie-links", app.protectedRoute("movie-links:write", app.createMovieLinkHandler))
	router.HandlerFunc(http.MethodGet, "/v1/movie-links/:id", app.protectedRoute("movie-links:read", app.getMovieLinksHandler))       //expects movieId
	router.HandlerFunc(http.MethodDelete, "/v1/movie-links/:id", app.protectedRoute("movie-links:write", app.deleteMovieLinkHandler)) //expects id from movie_links

	router.HandlerFunc(http.MethodPost, "/v1/people-links", app.protectedRoute("people-links:write", app.createPeopleLinkHandler))
	router.HandlerFunc(http.MethodGet, "/v1/people-links/:id", app.protectedRoute("people-links:read", app.getPeopleLinksHandler))       //expects personId
	router.HandlerFunc(http.MethodDelete, "/v1/people-links/:id", app.protectedRoute("people-links:write", app.deletePeopleLinkHandler)) //expects id from people_links

	router.HandlerFunc(http.MethodPost, "/v1/trailers", app.protectedRoute("trailers:write", app.createTrailerHandler))
	router.HandlerFunc(http.MethodGet, "/v1/trailers/:id", app.protectedRoute("trailers:read", app.getTrailersHandler)) //expects movieId
	router.HandlerFunc(http.MethodDelete, "/v1/trailers/:id", app.protectedRoute("trailers:write", app.deleteTrailerHandler))

	router.HandlerFunc(http.MethodPost, "/v1/images", app.protectedRoute("images:write", app.createImageHandler))
	router.HandlerFunc(http.MethodGet, "/v1/images/:id", app.protectedRoute("images:read", app.getImageHandler))
	router.HandlerFunc(http.MethodGet, "/v1/images", app.protectedRoute("images:read", app.getImagesObjektIdHandler))
	router.HandlerFunc(http.MethodPatch, "/v1/images/:id", app.protectedRoute("images:write", app.updateImageHandler))
	router.HandlerFunc(http.MethodDelete, "/v1/images/:id", app.protectedRoute("images:write", app.deleteImageHandler))

	router.HandlerFunc(http.MethodPost, "/v1/users", app.registerUserHandler)
	router.HandlerFunc(http.MethodPut, "/v1/users/activate", app.authRateLimit(app.activateUserHandler))
	router.HandlerFunc(http.MethodPost, "/v1/users/resend-activation-token", app.authRateLimit(app.resendActionToken))
	router.HandlerFunc(http.MethodPost, "/v1/users/change-email", app.authRateLimit(app.protectedRoute("", app.changeEmailHandler)))
	router.HandlerFunc(http.MethodPut, "/v1/users/change-email-verify", app.authRateLimit(app.protectedRoute("", app.changeEmailVerifyTokenHandler)))

	router.HandlerFunc(http.MethodPost, "/v1/auth/authentication", app.authRateLimit(app.authenticateUserHandler))
	router.HandlerFunc(http.MethodPost, "/v1/auth/reset-password", app.authRateLimit(app.resetPasswordHandler))
	router.HandlerFunc(http.MethodPost, "/v1/auth/reset-password-verify", app.authRateLimit(app.resetPasswordVerifyHandler))
	router.HandlerFunc(http.MethodPost, "/v1/auth/change-password", app.authRateLimit(app.protectedRoute("", app.changePasswordHandler)))
	router.HandlerFunc(http.MethodPost, "/v1/auth/revoke", app.protectedRoute("", app.deleteAllSessionsHandler))

	// router.Handler(http.MethodGet, "/metrics", expvar.Handler())

	//Admin swap permission
	router.HandlerFunc(http.MethodPost, "/v1/users/permissions/:id", app.protectedRoute("admin:write", app.addUserPermissionsHandler))

	router.HandlerFunc(http.MethodGet, "/", app.getDocs)
	return app.panicRecovery(app.rateLimit(app.authenticate(router)))
}
