CREATE TABLE drivers (
    driver_id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    initials TEXT NOT NULL,
    UNIQUE (last_name, initials)
);

CREATE TABLE buses (
    bus_id INTEGER PRIMARY KEY AUTOINCREMENT,
    bus_number TEXT NOT NULL UNIQUE
);

CREATE TABLE routes (
    route_id INTEGER PRIMARY KEY AUTOINCREMENT,
    destination TEXT NOT NULL,
    route_path TEXT NOT NULL,
    UNIQUE (destination, route_path)
);

CREATE TABLE trips (
    trip_id INTEGER PRIMARY KEY AUTOINCREMENT,
    trip_number TEXT NOT NULL,
    route_id INTEGER REFERENCES routes(route_id),
    bus_id INTEGER REFERENCES buses(bus_id),
    driver_id INTEGER REFERENCES drivers(driver_id),
    departure_time TEXT NOT NULL,
    arrival_time TEXT NOT NULL,
    UNIQUE (trip_number),
    CHECK (arrival_time > departure_time)
);
