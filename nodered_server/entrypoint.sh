#!/bin/sh

export PATH="/usr/lib/postgresql/13/bin:$PATH"

# Start PostgreSQL
su postgres -c 'pg_ctl start -D /data/postgres_db_dir -l /data/postgres_db_dir/log'

# Wait for PostgreSQL to be ready
until su postgres -c 'pg_isready' 2>/dev/null; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 1
done

# Run SQL initialization commands
if [ -f /src/create_db.sql ]; then
  echo "Creating databases with create_db.sql..."
  su postgres -c 'psql -f /src/create_db.sql'
else
  echo "No create_db.sql found in the src folder! skipping database creation..."
fi


# Initialize passenger_information_system
if [ -f /src/init_pis_db.sql ]; then
  echo "Initializing passenger_information_system..."
  su postgres -c 'psql -d passenger_information_system -f /src/init_pis_db.sql'
else
  echo "No init_pis_db.sql found at /src directory!  skipping passenger_information_system initialization..."
fi

# Initialize gateway_DB
if [ -f /src/init_gateway_db.sql ]; then
  echo "Initializing gateway_DB..."
  su postgres -c 'psql -d gateway_db -f /src/init_gateway_db.sql'
else
  echo "No init_gateway_db.sql found at /src directory!  skipping gateway_DB initialization..."
fi

# Start Mosquitto
mosquitto -d

# Start Node-RED
node-red --userDir /data/node-red &

# Keep the container running
tail -f /dev/null