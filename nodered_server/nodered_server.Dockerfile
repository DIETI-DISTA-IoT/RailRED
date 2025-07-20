# Use Alpine Linux as base image
FROM alpine:latest

# Install necessary packages: Node.js, npm, PostgreSQL, Mosquitto, OpenSSL
RUN apk update && \
    apk add --no-cache nodejs npm postgresql \
    postgresql-contrib postgresql-client mosquitto \
    mosquitto-clients openssl python3 \
    py3-requests

# Install Node-RED globally
RUN npm install -g --unsafe-perm node-red

# Install necessarry libs for our Node-RED server
RUN npm install -g @stdlib/random-array-weibull \
                node-red-contrib-crypto-js \
                node-red-contrib-postgresql \
                node-red-dashboard

# Create directories for data and configuration
RUN mkdir -p /data/node-red /data/postgres_db_dir /run/postgresql

# Copy Node-RED settings file
COPY nodered_settings.js /data/node-red/settings.js

# Copy additional data files if needed
COPY data/* /data/
COPY src/*  /src/

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER root
# Ensure Node-RED can access global npm modules
ENV NODE_PATH=/usr/local/lib/node_modules

# Give permissions to the postgres user
RUN chown -R postgres:postgres /data/postgres_db_dir /run/postgresql
# Expose necessary ports
EXPOSE 1880 5432 1883

USER postgres
# Initialize the PostgreSQL database cluster
RUN initdb -D /data/postgres_db_dir

USER root

COPY TCMS.json data/node-red/TCMS.json



ENTRYPOINT ["/entrypoint.sh"]