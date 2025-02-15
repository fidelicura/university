WITH active_trips AS (
    SELECT 
        t.trip_id,
        t.trip_number,
        t.bus_id,
        t.driver_id,
        t.route_id,
        t.departure_time,
        t.arrival_time,
        r.destination,
        r.route_path
    FROM trips t
    JOIN routes r ON t.route_id = r.route_id
    WHERE '2025-02-15 15:30:00' BETWEEN t.departure_time AND t.arrival_time
),
reachable_routes AS (
    SELECT 
        route_id,
        destination,
        route_path
    FROM routes
    WHERE destination = 'Москва'
       OR route_path LIKE '%Москва%'
)
SELECT 
    a.trip_id,
    a.trip_number,
    a.bus_id,
    a.driver_id,
    a.departure_time,
    a.arrival_time,
    a.destination,
    a.route_path
FROM active_trips a
JOIN reachable_routes rr ON a.route_id = rr.route_id;
