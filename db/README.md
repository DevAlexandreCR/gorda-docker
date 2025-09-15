# PostgreSQL Database Service with PostGIS

This directory contains the PostgreSQL database service configuration with PostGIS extension for the Gorda application.

## Structure

- `Dockerfile` - PostgreSQL with PostGIS container configuration
- `init-db.sh` - Database initialization script with PostGIS setup
- `.env.example` - Environment variables template

## Database Configuration

### PostGIS Extensions

The database includes the following PostGIS extensions:

- **postgis** - Core PostGIS functionality for spatial data
- **postgis_topology** - Topology support for complex spatial relationships
- **fuzzystrmatch** - Fuzzy string matching for geocoding
- **postgis_tiger_geocoder** - TIGER geocoder for US address geocoding

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

## PostGIS Features

With PostGIS enabled, the database supports:

- **Spatial Data Types**: GEOMETRY, GEOGRAPHY for storing spatial data
- **Spatial Functions**: Distance calculations, area measurements, intersections
- **Spatial Indexing**: GiST indexes for efficient spatial queries
- **Coordinate Systems**: Support for various spatial reference systems (SRS)
- **Geocoding**: Address to coordinate conversion capabilities

### Example Spatial Queries

```sql
-- Create a table with spatial data
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    geom GEOMETRY(POINT, 4326)
);

-- Insert a point (longitude, latitude)
INSERT INTO locations (name, geom) 
VALUES ('Sample Location', ST_GeomFromText('POINT(-74.0060 40.7128)', 4326));

-- Find distances between points
SELECT name, ST_Distance(geom, ST_GeomFromText('POINT(-74.0060 40.7128)', 4326)) as distance
FROM locations;
```

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
