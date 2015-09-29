--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actors; Type: TABLE; Schema: public; Owner: justinhuynh; Tablespace: 
--

CREATE TABLE actors (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE actors OWNER TO justinhuynh;

--
-- Name: actors_id_seq; Type: SEQUENCE; Schema: public; Owner: justinhuynh
--

CREATE SEQUENCE actors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE actors_id_seq OWNER TO justinhuynh;

--
-- Name: actors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: justinhuynh
--

ALTER SEQUENCE actors_id_seq OWNED BY actors.id;


--
-- Name: cast_members; Type: TABLE; Schema: public; Owner: justinhuynh; Tablespace: 
--

CREATE TABLE cast_members (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    actor_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "character" character varying(255)
);


ALTER TABLE cast_members OWNER TO justinhuynh;

--
-- Name: cast_members_id_seq; Type: SEQUENCE; Schema: public; Owner: justinhuynh
--

CREATE SEQUENCE cast_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cast_members_id_seq OWNER TO justinhuynh;

--
-- Name: cast_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: justinhuynh
--

ALTER SEQUENCE cast_members_id_seq OWNED BY cast_members.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: justinhuynh; Tablespace: 
--

CREATE TABLE genres (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE genres OWNER TO justinhuynh;

--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: justinhuynh
--

CREATE SEQUENCE genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE genres_id_seq OWNER TO justinhuynh;

--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: justinhuynh
--

ALTER SEQUENCE genres_id_seq OWNED BY genres.id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: justinhuynh; Tablespace: 
--

CREATE TABLE movies (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    year integer NOT NULL,
    synopsis text,
    rating integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    genre_id integer NOT NULL,
    studio_id integer
);


ALTER TABLE movies OWNER TO justinhuynh;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: justinhuynh
--

CREATE SEQUENCE movies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE movies_id_seq OWNER TO justinhuynh;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: justinhuynh
--

ALTER SEQUENCE movies_id_seq OWNED BY movies.id;


--
-- Name: studios; Type: TABLE; Schema: public; Owner: justinhuynh; Tablespace: 
--

CREATE TABLE studios (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE studios OWNER TO justinhuynh;

--
-- Name: studios_id_seq; Type: SEQUENCE; Schema: public; Owner: justinhuynh
--

CREATE SEQUENCE studios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE studios_id_seq OWNER TO justinhuynh;

--
-- Name: studios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: justinhuynh
--

ALTER SEQUENCE studios_id_seq OWNED BY studios.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: justinhuynh
--

ALTER TABLE ONLY actors ALTER COLUMN id SET DEFAULT nextval('actors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: justinhuynh
--

ALTER TABLE ONLY cast_members ALTER COLUMN id SET DEFAULT nextval('cast_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: justinhuynh
--

ALTER TABLE ONLY genres ALTER COLUMN id SET DEFAULT nextval('genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: justinhuynh
--

ALTER TABLE ONLY movies ALTER COLUMN id SET DEFAULT nextval('movies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: justinhuynh
--

ALTER TABLE ONLY studios ALTER COLUMN id SET DEFAULT nextval('studios_id_seq'::regclass);


--
-- Name: actors_pkey; Type: CONSTRAINT; Schema: public; Owner: justinhuynh; Tablespace: 
--

ALTER TABLE ONLY actors
    ADD CONSTRAINT actors_pkey PRIMARY KEY (id);


--
-- Name: cast_members_pkey; Type: CONSTRAINT; Schema: public; Owner: justinhuynh; Tablespace: 
--

ALTER TABLE ONLY cast_members
    ADD CONSTRAINT cast_members_pkey PRIMARY KEY (id);


--
-- Name: genres_pkey; Type: CONSTRAINT; Schema: public; Owner: justinhuynh; Tablespace: 
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: movies_pkey; Type: CONSTRAINT; Schema: public; Owner: justinhuynh; Tablespace: 
--

ALTER TABLE ONLY movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: studios_pkey; Type: CONSTRAINT; Schema: public; Owner: justinhuynh; Tablespace: 
--

ALTER TABLE ONLY studios
    ADD CONSTRAINT studios_pkey PRIMARY KEY (id);


--
-- Name: movies_idx; Type: INDEX; Schema: public; Owner: justinhuynh; Tablespace: 
--

CREATE INDEX movies_idx ON movies USING gin (to_tsvector('simple'::regconfig, synopsis));


--
-- Name: public; Type: ACL; Schema: -; Owner: justinhuynh
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM justinhuynh;
GRANT ALL ON SCHEMA public TO justinhuynh;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

