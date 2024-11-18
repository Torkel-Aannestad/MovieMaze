package main

import (
	"context"
	"database/sql"
	"flag"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"time"

	"github.com/Torkel-Aannestad/MovieMaze/internal/database"
	"github.com/Torkel-Aannestad/MovieMaze/internal/mailer"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

const version = "1.0.0"

type config struct {
	port int
	env  string
	db   struct {
		dsn          string
		maxOpenConns int
		maxIdleConns int
		maxIdleTime  time.Duration
	}
	limiter struct {
		rps     float64
		burst   int
		enabled bool
	}
	smtp struct {
		host     string
		port     int
		username string
		password string
		sender   string
	}
}

type application struct {
	config config
	logger *slog.Logger
	model  *database.Queries
	mailer mailer.Mailer
}

func main() {
	var cfg config

	godotenv.Load()
	dns := os.Getenv("MOVIE_MAZE_DB_DSN")
	mailtrapUsername := os.Getenv("MAILTRAP_USERNAME")
	mailtrapPassword := os.Getenv("MAILTRAP_PASSWORD")

	flag.IntVar(&cfg.port, "port", 4000, "port to listen for request")
	flag.StringVar(&cfg.env, "env", "development", "development | staging | production")

	//DB flags
	flag.StringVar(&cfg.db.dsn, "db-dsn", dns, "dsn for PG instance")
	flag.IntVar(&cfg.db.maxOpenConns, "db-max-open-conns", 25, "PostgreSQL max open connections")
	flag.IntVar(&cfg.db.maxIdleConns, "db-max-idle-conns", 25, "PostgreSQL max idle connections")
	flag.DurationVar(&cfg.db.maxIdleTime, "db-max-idle-time", 15*time.Minute, "PostgreSQL max connection idle time")

	//Rate limiter
	flag.Float64Var(&cfg.limiter.rps, "limiter-rps", 2, "Rate limiter maximum requests per second")
	flag.IntVar(&cfg.limiter.burst, "limiter-burst", 4, "Rate limiter maximum burst")
	flag.BoolVar(&cfg.limiter.enabled, "limiter-enabled", true, "Enable rate limiter")

	//Mailer
	flag.StringVar(&cfg.smtp.host, "smtp-host", "sandbox.smtp.mailtrap.io", "SMTP host")
	flag.IntVar(&cfg.smtp.port, "smtp-port", 25, "SMTP port")
	flag.StringVar(&cfg.smtp.username, "smtp-username", mailtrapUsername, "SMTP username")
	flag.StringVar(&cfg.smtp.password, "smtp-password", mailtrapPassword, "SMTP password")
	flag.StringVar(&cfg.smtp.sender, "smtp-sender", "MovieMaze <no-reply@moviemaze.easywave.io>", "SMTP sender")

	flag.Parse()

	logger := slog.New(slog.NewTextHandler(os.Stdout, nil)) //change for json later

	db, err := openDB(cfg)
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}
	defer db.Close()
	logger.Info("database connection pool established")

	model := database.New(db)

	app := &application{
		config: cfg,
		logger: logger,
		model:  model,
	}

	srv := &http.Server{
		Addr:         fmt.Sprintf(":%v", cfg.port),
		Handler:      app.routes(),
		ReadTimeout:  time.Second * 5,
		WriteTimeout: time.Second * 10,
		IdleTimeout:  time.Second * 60,
		ErrorLog:     slog.NewLogLogger(logger.Handler(), slog.LevelError),
	}
	logger.Info("starting server", "port", cfg.port)

	err = srv.ListenAndServe()
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}

}

func openDB(cfg config) (*sql.DB, error) {
	db, err := sql.Open("postgres", cfg.db.dsn)
	if err != nil {
		return nil, err
	}

	db.SetMaxOpenConns(cfg.db.maxOpenConns)
	db.SetMaxIdleConns(cfg.db.maxIdleConns)
	db.SetConnMaxIdleTime(cfg.db.maxIdleTime)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	err = db.PingContext(ctx)
	if err != nil {
		db.Close()
		return nil, err
	}
	return db, nil

}
