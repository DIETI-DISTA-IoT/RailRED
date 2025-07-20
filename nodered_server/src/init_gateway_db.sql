CREATE TABLE IF NOT EXISTS diagnostics (
    event_id SERIAL PRIMARY KEY,
    train_id VARCHAR(30) NOT NULL,
    event_timestamp TIMESTAMP NOT NULL,
    event_code VARCHAR(30) NOT NULL,
    event_name VARCHAR(30) NOT NULL,
    component VARCHAR(30),
    event_description VARCHAR (150),
    cluster_id NUMERIC
    );

/*From the TCMS flow file:*/
CREATE TABLE IF NOT EXISTS train_Temperature (
    temperature DECIMAL
    );

CREATE TABLE IF NOT EXISTS train_Humidity (
    humidity DECIMAL
    );

CREATE TABLE IF NOT EXISTS train_Pressure (
    pressure DECIMAL
    );
CREATE TABLE IF NOT EXISTS braking_speed (
    speed NUMERIC
    );
CREATE TABLE IF NOT EXISTS braking_temp (
    temp NUMERIC
    );
CREATE TABLE IF NOT EXISTS braking_pres (
    pres DECIMAL
    );
CREATE TABLE IF NOT EXISTS train_Pressure_supportLine (
    pressure_support DECIMAL
    );
CREATE TABLE IF NOT EXISTS CCTV_presence (
    presence DECIMAL
    );