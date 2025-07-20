
CREATE TABLE IF NOT EXISTS train_PIS (
    id SERIAL PRIMARY KEY,
    train_id VARCHAR(50) NOT NULL,
    destination VARCHAR(100),
    departure_time TIME,
    arrival_time TIME,  
    distance_in_km INTEGER,
    seats_available INTEGER
);