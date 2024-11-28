--
-- PostgreSQL database dump
--

-- Dumped from database version 14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: kind; Type: TYPE; Schema: public; Owner: movie_maze
--

CREATE TYPE public.kind AS ENUM (
    'movie',
    'series',
    'season',
    'episode',
    'movieseries'
);


ALTER TYPE public.kind OWNER TO movie_maze;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: casts; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.casts (
    movie_id bigint NOT NULL,
    person_id bigint NOT NULL,
    job_id bigint NOT NULL,
    role text NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.casts OWNER TO movie_maze;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    parent_id bigint,
    root_id bigint,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categories OWNER TO movie_maze;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.categories ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: goose_db_version; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.goose_db_version (
    id integer NOT NULL,
    version_id bigint NOT NULL,
    is_applied boolean NOT NULL,
    tstamp timestamp without time zone DEFAULT now()
);


ALTER TABLE public.goose_db_version OWNER TO movie_maze;

--
-- Name: goose_db_version_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

CREATE SEQUENCE public.goose_db_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.goose_db_version_id_seq OWNER TO movie_maze;

--
-- Name: goose_db_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: movie_maze
--

ALTER SEQUENCE public.goose_db_version_id_seq OWNED BY public.goose_db_version.id;


--
-- Name: image_ids; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.image_ids (
    id bigint NOT NULL,
    object_id bigint NOT NULL,
    object_type text NOT NULL,
    image_version integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.image_ids OWNER TO movie_maze;

--
-- Name: image_ids_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.image_ids ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.image_ids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: image_licenses; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.image_licenses (
    image_id bigint NOT NULL,
    source text NOT NULL,
    license_id bigint NOT NULL,
    author text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.image_licenses OWNER TO movie_maze;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.jobs OWNER TO movie_maze;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.jobs ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: movie_categories; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.movie_categories (
    movie_id bigint NOT NULL,
    category_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movie_categories OWNER TO movie_maze;

--
-- Name: movie_keywords; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.movie_keywords (
    movie_id bigint NOT NULL,
    category_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movie_keywords OWNER TO movie_maze;

--
-- Name: movie_links; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.movie_links (
    source text NOT NULL,
    key text NOT NULL,
    movie_id bigint NOT NULL,
    language text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movie_links OWNER TO movie_maze;

--
-- Name: movie_references; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.movie_references (
    movie_id bigint NOT NULL,
    referenced_id bigint NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movie_references OWNER TO movie_maze;

--
-- Name: movies; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.movies (
    id bigint NOT NULL,
    name text NOT NULL,
    parent_id bigint,
    date date NOT NULL,
    series_id bigint,
    kind public.kind NOT NULL,
    runtime integer NOT NULL,
    budget double precision NOT NULL,
    revenue double precision NOT NULL,
    homepage text NOT NULL,
    vote_average double precision NOT NULL,
    votes_count bigint NOT NULL,
    abstract text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movies OWNER TO movie_maze;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.movies ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.movies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.people (
    id bigint NOT NULL,
    name text NOT NULL,
    birthday date NOT NULL,
    deathday date NOT NULL,
    gender integer NOT NULL,
    aliases text[],
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.people OWNER TO movie_maze;

--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.people ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: people_links; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.people_links (
    source text NOT NULL,
    key text NOT NULL,
    person_id bigint NOT NULL,
    language text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.people_links OWNER TO movie_maze;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    code text NOT NULL
);


ALTER TABLE public.permissions OWNER TO movie_maze;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.tokens (
    hash bytea NOT NULL,
    user_id bigint NOT NULL,
    expiry timestamp(0) with time zone NOT NULL,
    scope text NOT NULL
);


ALTER TABLE public.tokens OWNER TO movie_maze;

--
-- Name: trailers; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.trailers (
    trailer_id bigint NOT NULL,
    key text NOT NULL,
    movie_id bigint NOT NULL,
    language text NOT NULL,
    source text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.trailers OWNER TO movie_maze;

--
-- Name: TABLE trailers; Type: COMMENT; Schema: public; Owner: movie_maze
--

COMMENT ON TABLE public.trailers IS 'Youtube/Vimeo Trailer';


--
-- Name: trailers_trailer_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.trailers ALTER COLUMN trailer_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.trailers_trailer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp(0) with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    email public.citext NOT NULL,
    password_hash bytea NOT NULL,
    activated boolean NOT NULL,
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.users OWNER TO movie_maze;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: movie_maze
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users_permissions; Type: TABLE; Schema: public; Owner: movie_maze
--

CREATE TABLE public.users_permissions (
    user_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE public.users_permissions OWNER TO movie_maze;

--
-- Name: goose_db_version id; Type: DEFAULT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.goose_db_version ALTER COLUMN id SET DEFAULT nextval('public.goose_db_version_id_seq'::regclass);


--
-- Name: casts casts_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.casts
    ADD CONSTRAINT casts_pkey PRIMARY KEY (movie_id, person_id, job_id, role, "position");


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: goose_db_version goose_db_version_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.goose_db_version
    ADD CONSTRAINT goose_db_version_pkey PRIMARY KEY (id);


--
-- Name: image_ids image_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.image_ids
    ADD CONSTRAINT image_ids_pkey PRIMARY KEY (id);


--
-- Name: image_licenses image_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.image_licenses
    ADD CONSTRAINT image_licenses_pkey PRIMARY KEY (image_id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: movie_categories movie_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_categories
    ADD CONSTRAINT movie_categories_pkey PRIMARY KEY (movie_id, category_id);


--
-- Name: movie_keywords movie_keywords_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_keywords
    ADD CONSTRAINT movie_keywords_pkey PRIMARY KEY (movie_id, category_id);


--
-- Name: movie_links movie_links_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_links
    ADD CONSTRAINT movie_links_pkey PRIMARY KEY (movie_id, language, key);


--
-- Name: movie_references movie_references_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_references
    ADD CONSTRAINT movie_references_pkey PRIMARY KEY (movie_id, referenced_id, type);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: people_links people_links_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.people_links
    ADD CONSTRAINT people_links_pkey PRIMARY KEY (person_id, language, key);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (hash);


--
-- Name: trailers trailers_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.trailers
    ADD CONSTRAINT trailers_pkey PRIMARY KEY (movie_id, trailer_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_permissions users_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.users_permissions
    ADD CONSTRAINT users_permissions_pkey PRIMARY KEY (user_id, permission_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: casts casts_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.casts
    ADD CONSTRAINT casts_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE CASCADE;


--
-- Name: casts casts_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.casts
    ADD CONSTRAINT casts_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: casts casts_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.casts
    ADD CONSTRAINT casts_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: categories categories_root_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_root_id_fkey FOREIGN KEY (root_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: image_licenses image_licenses_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.image_licenses
    ADD CONSTRAINT image_licenses_image_id_fkey FOREIGN KEY (image_id) REFERENCES public.image_ids(id) ON DELETE CASCADE;


--
-- Name: movie_categories movie_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_categories
    ADD CONSTRAINT movie_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: movie_categories movie_categories_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_categories
    ADD CONSTRAINT movie_categories_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_keywords movie_keywords_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_keywords
    ADD CONSTRAINT movie_keywords_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: movie_keywords movie_keywords_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_keywords
    ADD CONSTRAINT movie_keywords_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_links movie_links_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_links
    ADD CONSTRAINT movie_links_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_references movie_references_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_references
    ADD CONSTRAINT movie_references_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movie_references movie_references_referenced_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movie_references
    ADD CONSTRAINT movie_references_referenced_id_fkey FOREIGN KEY (referenced_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movies movies_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: movies movies_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_series_id_fkey FOREIGN KEY (series_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: people_links people_links_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.people_links
    ADD CONSTRAINT people_links_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: tokens tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: trailers trailers_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.trailers
    ADD CONSTRAINT trailers_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON DELETE CASCADE;


--
-- Name: users_permissions users_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.users_permissions
    ADD CONSTRAINT users_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: users_permissions users_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: movie_maze
--

ALTER TABLE ONLY public.users_permissions
    ADD CONSTRAINT users_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

