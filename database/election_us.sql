create user election_us_backenduser with password 'gwitbDr+zp4iK3dn';
GRANT USAGE ON SCHEMA public to  election_us_backenduser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON tables TO election_us_backenduser;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO election_us_backenduser;
GRANT SELECT, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO election_us_backenduser;

CREATE TYPE valg_typer AS ENUM (
  'P',
  'G',
  'H',
  'S'
);


CREATE TABLE valg (
  id SERIAL PRIMARY KEY,
  key VARCHAR(25) NOT NULL,
  name VARCHAR(255) NOT NULL,
  type valg_typer NOT NULL,
  creation_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  expire_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP + INTERVAL '1 month' NOT NULL
);

ALTER TABLE valg ADD CONSTRAINT valg_key UNIQUE (key);
CREATE INDEX idx_valg_key ON valg(key);

CREATE TABLE state (
    id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(255),
    PRIMARY KEY(id)
);


CREATE TABLE kandidat (
  id SERIAL NOT NULL,
  parti_id INT,
  valg_id INTEGER NOT NULL,
  firstname VARCHAR(255) NOT NULL,
  lastname VARCHAR(255) NOT NULL,
  pol_id INT NOT NULL,
  incumbent boolean not null default false,
  ballotOrder int not null default 0,
  PRIMARY KEY(id, valg_id)  
);
ALTER TABLE kandidat ADD CONSTRAINT kandidat_valg_pol UNIQUE (valg_id, pol_id);


CREATE TABLE parti (
  id SERIAL NOT NULL,
  valg_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  short_name VARCHAR(255),
  letter VARCHAR(5) NOT NULL,
  PRIMARY KEY(id, valg_id)
);

CREATE TABLE kandidat_in_state (
  kandidat_id INTEGER NOT NULL,
  state_id INTEGER NOT NULL,
  valg_id INTEGER NOT NULL,
  PRIMARY KEY(kandidat_id, state_id, valg_id)
);


CREATE TABLE blok (
  id SERIAL NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE parti_in_blok (
  valg_id INTEGER NOT NULL,
  parti_id INTEGER NOT NULL,
  blok_id INTEGER NOT NULL,
  PRIMARY KEY(valg_id, parti_id, blok_id)
);


create table service_manager (
  id serial not null,
  host varchar(200) not null, 
  updated_at timestamp without time zone not null default now(), 
  master boolean default false,
  primary key(id)
);

create unique index on service_manager (host);
create unique index on service_manager (master) where master = true;

create table notifications (
    id bigint not null,
    key varchar(50) not null, 
    name varchar(100) not null,
    primary key(id)
);
create unique index on notifications (key,name);


insert into blok values (0,'none');
insert into blok values (1,'Republican');
insert into blok values (2,'Democrats');




create view v_kandidat_in_state as 
select distinct kand.id as kandidat_id, kand.*, stat.id as state_id 
from kandidat as kand
     left join kandidat_in_state as kis on (kand.id = kis.kandidat_id)
     left join state as stat on (stat.id = kis.state_id);



create table demo (
   id serial PRIMARY KEY,
   kandidat_id INTEGER,   
   name varchar(200), 
   party varchar(200), 
   title varchar(200), 
   birthday varchar(200), 
   age int, 
   image varchar(200), 
   facebook varchar(200), 
   twitter varchar(200),   
   children text
);

