#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE TABLE IF NOT EXISTS  people (
        person_id uuid DEFAULT uuid_generate_v4 (),
        name VARCHAR NOT NULL,
        PRIMARY KEY (person_id)
    );
EOSQL