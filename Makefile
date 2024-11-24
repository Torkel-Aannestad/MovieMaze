include .env

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

## run/api: run the cmd/api application
.PHONY: run/api
run/api:
	go run ./cmd/api -db-dsn=${MOVIE_MAZE_DB_DSN} 

## live/server: run air
.PHONY: live/server
live/server:
	air

## db/psql: connect to the database using psql
.PHONY: db/psql
db/psql:
	psql ${MOVIE_MAZE_DB_DSN}

## db/migrations/up: apply all up database migrations
.PHONY: db/migrations/up
db/migrations/up: confirm
	@echo 'Running up migrations...'
	@cd sql/schema && goose postgres ${MOVIE_MAZE_DB_DSN} up && cd ../..

## db/sqlc/generate: slqc generates go types from database schema and queries
.PHONY: db/sqlc/generate
db/sqlc/generate:
	sqlc generate

## db/init: initialize a docker postress container
.PHONY: db/init
db/init:
	@docker run -e POSTGRES_PASSWORD=${DOCKER_POSTGRES_PW} --name=${DOCKER_POSTGRES_CONTAINER_NAME} --rm -d -p 5432:5432 postgres && sleep 3
	@docker exec -u postgres -it pg-moviemaze psql -c "CREATE DATABASE moviemaze;"

### Not done
## db/download-omdb: downloading newest dataset from OMDB
.PHONY: db/download-omdb
db/download-omdb:
	@echo "## db/download-omdb: downloading newest dataset from OMDB"
	@for f in $(FILES); do \
		echo "Downloading $$f.csv.bz2..."; \
		wget --no-verbose $(BASE_URL)$$f.csv.bz2 -P www.omdb.org/data/; \
		echo "Extracting $$f.csv.bz2..."; \
		bunzip2 --keep --force www.omdb.org/data/$$f.csv.bz2; \
	done
	

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## audit: tidy and vendor dependencies and format, vet and test all code
.PHONY: audit
audit: vendor
	@echo 'Formatting code...'
	go fmt ./...
	@echo 'Vetting code...'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests...'
	go test -race -vet=off ./...

## vendor: tidy and vendor dependencies
.PHONY: vendor
vendor:
	@echo 'Tidying and verifying module dependencies...'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies...'
	go mod vendor

# ==================================================================================== #
# BUILD
# ==================================================================================== #

## build/api: build the cmd/api application
.PHONY: build/api
build/api:
	@echo 'Building cmd/api...'
	go build -ldflags='-s' -o=./bin/moviemaze-app ./cmd/api
	GOOS=linux GOARCH=amd64 go build -ldflags='-s' -o=./bin/linux_amd64/moviemaze-app ./cmd/api


# ==================================================================================== #
# PRODUCTION
# ==================================================================================== #

## production/connect: connect to the production server
.PHONY: production/connect
production/connect:
	ssh moviemaze@${PRODUCTION_HOST_IP}

## production/deploy/api: deploy the api to production
.PHONY: production/deploy/app
production/deploy/app:
	rsync -P ./bin/linux_amd64/moviemaze-app moviemaze@${PRODUCTION_HOST_IP}:~
	rsync -rP --delete ./sql/schema/ moviemaze@${PRODUCTION_HOST_IP}:~/migrations
	ssh -t moviemaze@${PRODUCTION_HOST_IP} 'cd migrations && goose postgres ${MOVIE_MAZE_DB_DSN} up && cd ..'
	rsync -P ./remote/production/moviemaze.service moviemaze@${PRODUCTION_HOST_IP}:~
	ssh -t moviemaze@${PRODUCTION_HOST_IP} '\
	sudo mv ~/moviemaze.service /etc/systemd/system/ \
	&& sudo systemctl enable moviemaze \
	&& sudo systemctl restart moviemaze \
	'
	@echo "deployment complete..."
