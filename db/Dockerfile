FROM postgres:15-alpine

# Install additional packages and create database directory
RUN apk add --no-cache bash curl && \
    mkdir -p /var/lib/postgresql/data

# Copy initialization scripts
COPY init-db.sh /docker-entrypoint-initdb.d/

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

EXPOSE 5432

# Use the default postgres entrypoint
CMD ["postgres"]
