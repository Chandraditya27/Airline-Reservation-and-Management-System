-- seats available = seats for aircraft minus reserved/confirmed seats for this flight instance
SELECT s.id, s.seat_label, s.cabin_class
FROM seat s
JOIN flight f ON f.aircraft_id = s.aircraft_id
JOIN flight_instance fi ON fi.flight_id = f.id
WHERE fi.id = 1
  AND s.id NOT IN (
    SELECT sr.seat_id FROM seat_reservation sr
    WHERE sr.flight_instance_id = 1 AND sr.status IN ('Held','Confirmed')
  );

-- List upcoming flights between two airports
SELECT fi.*, f.flight_number, a1.iata AS origin, a2.iata AS dest
FROM flight_instance fi
JOIN flight f ON fi.flight_id = f.id
JOIN airport a1 ON f.origin_airport_id = a1.id
JOIN airport a2 ON f.dest_airport_id = a2.id
WHERE a1.iata='DEL' AND a2.iata='BOM' AND fi.departure_datetime >= NOW()
ORDER BY fi.departure_datetime;

-- Cancel booking (soft cancel)
UPDATE booking SET status='Cancelled' WHERE booking_ref='ABC123';
UPDATE ticket SET ticket_status='Cancelled' WHERE booking_id = (SELECT id FROM booking WHERE booking_ref='ABC123');
-- optionally release seat_reservation rows
UPDATE seat_reservation sr
JOIN ticket t ON t.seat_id = sr.seat_id AND t.flight_instance_id = sr.flight_instance_id
SET sr.status='Released' WHERE t.booking_id = (SELECT id FROM booking WHERE booking_ref='ABC123');


