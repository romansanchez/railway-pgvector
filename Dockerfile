# Use the official pgvector image with Postgres 17
FROM pgvector/pgvector:pg17

# Expose the default Postgres port
EXPOSE 5432

# Set up a volume for persistent data
VOLUME /var/lib/postgresql/data

# Pass environment variables
ARG POSTGRES_PASSWORD POSTGRES_USER POSTGRES_DB

ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_DB=$POSTGRES_DB

# Copy the init.sql script into the container's initialization directory
COPY ./init.sql /docker-entrypoint-initdb.d/

# Add a health check to verify Postgres is ready
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" || exit 1

# Command to run Postgres (inherited from base image)
CMD ["postgres"]