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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying(255),
    body text,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: coworkers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE coworkers (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255)
);


--
-- Name: coworkers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE coworkers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coworkers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE coworkers_id_seq OWNED BY coworkers.id;


--
-- Name: daily_coworker_targets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE daily_coworker_targets (
    id integer NOT NULL,
    work_unit_id integer,
    coworker_id integer,
    target_id integer,
    day date,
    hours integer
);


--
-- Name: daily_coworker_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE daily_coworker_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_coworker_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE daily_coworker_targets_id_seq OWNED BY daily_coworker_targets.id;


--
-- Name: days_off_periods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE days_off_periods (
    id integer NOT NULL,
    coworker_id integer,
    period daterange,
    comment character varying(255)
);


--
-- Name: days_off_periods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE days_off_periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: days_off_periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE days_off_periods_id_seq OWNED BY days_off_periods.id;


--
-- Name: finance_invoices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE finance_invoices (
    id integer NOT NULL,
    dm2_id integer,
    number character varying(255),
    customer_name text,
    line_items hstore,
    euro integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    paid_at date
);


--
-- Name: finance_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE finance_invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finance_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE finance_invoices_id_seq OWNED BY finance_invoices.id;


--
-- Name: jira_exports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jira_exports (
    id integer NOT NULL,
    time_entry_id integer,
    processed_at timestamp without time zone,
    last_error text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jira_exports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jira_exports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_exports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jira_exports_id_seq OWNED BY jira_exports.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    resource_id integer,
    resource_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: targets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE targets (
    id integer NOT NULL,
    coworker_id integer,
    work_unit_id integer,
    hours_per_day integer DEFAULT 8,
    period daterange,
    cache_of_total_hours integer,
    type character varying(255),
    invoice_id integer
);


--
-- Name: targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE targets_id_seq OWNED BY targets.id;


--
-- Name: time_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE time_entries (
    id integer NOT NULL,
    coworker_id integer,
    work_unit_id integer,
    duration integer,
    comment text,
    period tstzrange
);


--
-- Name: time_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE time_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE time_entries_id_seq OWNED BY time_entries.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    provider character varying(255),
    uid character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_roles (
    user_id integer,
    role_id integer
);


--
-- Name: work_units; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE work_units (
    id integer NOT NULL,
    wuid character varying(255),
    name character varying(255),
    ancestry character varying(255),
    type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    period daterange,
    opts hstore,
    ancestry_depth integer DEFAULT 0
);


--
-- Name: work_units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE work_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE work_units_id_seq OWNED BY work_units.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY coworkers ALTER COLUMN id SET DEFAULT nextval('coworkers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_coworker_targets ALTER COLUMN id SET DEFAULT nextval('daily_coworker_targets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY days_off_periods ALTER COLUMN id SET DEFAULT nextval('days_off_periods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY finance_invoices ALTER COLUMN id SET DEFAULT nextval('finance_invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jira_exports ALTER COLUMN id SET DEFAULT nextval('jira_exports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY targets ALTER COLUMN id SET DEFAULT nextval('targets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY time_entries ALTER COLUMN id SET DEFAULT nextval('time_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY work_units ALTER COLUMN id SET DEFAULT nextval('work_units_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: coworker_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY targets
    ADD CONSTRAINT coworker_targets_pkey PRIMARY KEY (id);


--
-- Name: coworkers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY coworkers
    ADD CONSTRAINT coworkers_pkey PRIMARY KEY (id);


--
-- Name: daily_coworker_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY daily_coworker_targets
    ADD CONSTRAINT daily_coworker_targets_pkey PRIMARY KEY (id);


--
-- Name: days_off_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY days_off_periods
    ADD CONSTRAINT days_off_periods_pkey PRIMARY KEY (id);


--
-- Name: finance_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY finance_invoices
    ADD CONSTRAINT finance_invoices_pkey PRIMARY KEY (id);


--
-- Name: jira_exports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jira_exports
    ADD CONSTRAINT jira_exports_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: time_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY time_entries
    ADD CONSTRAINT time_entries_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: work_units_ancestry_period_excl; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY work_units
    ADD CONSTRAINT work_units_ancestry_period_excl EXCLUDE USING gist (ancestry WITH =, period WITH &&);


--
-- Name: work_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY work_units
    ADD CONSTRAINT work_units_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON roles USING btree (name, resource_type, resource_id);


--
-- Name: index_time_entries_on_coworker_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_time_entries_on_coworker_id ON time_entries USING btree (coworker_id);


--
-- Name: index_time_entries_on_work_unit_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_time_entries_on_work_unit_id ON time_entries USING btree (work_unit_id);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_roles_on_user_id_and_role_id ON users_roles USING btree (user_id, role_id);


--
-- Name: index_work_units_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_work_units_on_ancestry ON work_units USING btree (ancestry);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131023105949');

INSERT INTO schema_migrations (version) VALUES ('20131023105955');

INSERT INTO schema_migrations (version) VALUES ('20131118165709');

INSERT INTO schema_migrations (version) VALUES ('20131120151131');

INSERT INTO schema_migrations (version) VALUES ('20131121173634');

INSERT INTO schema_migrations (version) VALUES ('20131122123725');

INSERT INTO schema_migrations (version) VALUES ('20131203123256');

INSERT INTO schema_migrations (version) VALUES ('20131213194625');

INSERT INTO schema_migrations (version) VALUES ('20131227174156');

INSERT INTO schema_migrations (version) VALUES ('20131227174159');

INSERT INTO schema_migrations (version) VALUES ('20131228105250');

INSERT INTO schema_migrations (version) VALUES ('20131228105636');

INSERT INTO schema_migrations (version) VALUES ('20131228115135');

INSERT INTO schema_migrations (version) VALUES ('20131228135340');

INSERT INTO schema_migrations (version) VALUES ('20140103090005');

INSERT INTO schema_migrations (version) VALUES ('20140103193026');

INSERT INTO schema_migrations (version) VALUES ('20140227134512');

INSERT INTO schema_migrations (version) VALUES ('20140419093020');

INSERT INTO schema_migrations (version) VALUES ('20140419093126');

INSERT INTO schema_migrations (version) VALUES ('20140419093336');

INSERT INTO schema_migrations (version) VALUES ('20140419094302');

INSERT INTO schema_migrations (version) VALUES ('20140420133512');

INSERT INTO schema_migrations (version) VALUES ('20140420172729');

INSERT INTO schema_migrations (version) VALUES ('20140420184215');
