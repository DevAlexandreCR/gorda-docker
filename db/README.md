# PostgreSQL Database Service

This directory contains the PostgreSQL database service configuration for the Gorda application.

## Structure

- `Dockerfile` - PostgreSQL container configuration
- `init-db.sh` - Database initialization script
- `.env.example` - Environment variables template

## Database Configuration

### Default Credentials

- **Database Name**: `gorda_db`
- **PostgreSQL User**: `postgres`
- **PostgreSQL Password**: `postgres123`
- **Root User**: `root`
- **Root Password**: `root123`

### Environment Variables

The following environment variables are available for connecting services:

- `DB_HOST=postgres` - Database host (service name)
- `DB_PORT=5432` - Database port
- `DB_NAME=gorda_db` - Database name
- `DB_USER=root` - Database user
- `DB_PASSWORD=root123` - Database password

## Service Connection

The PostgreSQL service is connected to the `backend` network and can be accessed by:

- **IA Service** - AI/ML service for data processing
- **Gorda Service** - Main application service

Both services have the database connection environment variables configured automatically.

## Health Check

The PostgreSQL service includes a health check that verifies the database is ready to accept connections before dependent services start.

## Data Persistence

Database data is persisted using a named volume `postgres_data` to ensure data survives container restarts.

## Usage

The database service will automatically start when running:

```bash
docker-compose up
```

Services that depend on the database will wait for it to be healthy before starting.
