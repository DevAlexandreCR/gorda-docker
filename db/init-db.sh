#!/bin/bash
set -e

# This script will be executed during container initialization
# It creates the root user with the specified password

echo "Creating root user with password..."

# Create root user if it doesn't exist
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'root') THEN
            CREATE USER root WITH PASSWORD '$POSTGRES_ROOT_PASSWORD';
            ALTER USER root CREATEDB;
            ALTER USER root WITH SUPERUSER;
        END IF;
    END
    \$\$;
EOSQL

echo "Root user created successfully!"
