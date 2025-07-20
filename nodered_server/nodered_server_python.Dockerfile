# Use Node.js as the base image
FROM node:22-bullseye-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    postgresql \
    postgresql-contrib \
    mosquitto \
    mosquitto-clients \
    openssl \
    && rm -rf /var/lib/apt/lists/*


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
RUN /usr/lib/postgresql/*/bin/initdb -D /data/postgres_db_dir

USER root

COPY TCMS.json data/node-red/TCMS.json


# Create a virtual environment and install Python packages within it
# Install PyTorch and other Python packages
RUN pip3 install torch requests


ENTRYPOINT ["/entrypoint.sh"]