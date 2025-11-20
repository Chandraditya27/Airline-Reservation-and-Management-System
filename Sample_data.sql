-- Airports
INSERT INTO airport (iata, name, city, country, timezone) VALUES
('DEL','Indira Gandhi International','Delhi','India','Asia/Kolkata'),
('BOM','Chhatrapati Shivaji Maharaj Intl','Mumbai','India','Asia/Kolkata'),
('BLR','Kempegowda Intl','Bengaluru','India','Asia/Kolkata');

-- Airline
INSERT INTO airline (code,name) VALUES ('AI','AirIndia'), ('6E','Indigo');

-- Aircraft
INSERT INTO aircraft (registration, model, total_seats) VALUES
('VT-AAA','A320-200',180),
('VT-BBB','B737-800',189);

-- Seats (create a few seats for A320)
INSERT INTO seat (aircraft_id, seat_label, cabin_class, is_window, is_aisle)
VALUES
(1,'1A','First',FALSE,FALSE),
(1,'12A','Economy',TRUE,FALSE),
(1,'12B','Economy',FALSE,FALSE),
(1,'12C','Economy',FALSE,TRUE);

-- Flight template
INSERT INTO flight (airline_id, flight_number, origin_airport_id, dest_airport_id, duration_minutes, aircraft_id)
VALUES (1,'AI101',1,2,120,1);

-- Flight instance (a scheduled departure)
INSERT INTO flight_instance (flight_id, departure_datetime, arrival_datetime, gate)
VALUES (1,'2025-12-01 09:00:00','2025-12-01 11:00:00','A5');

-- passenger & booking & ticket
INSERT INTO passenger (first_name,last_name,email) VALUES ('Ravi','Kumar','ravi@example.com');
INSERT INTO booking (booking_ref, booked_by_passenger_id, total_amount, status) VALUES ('ABC123',1,5000,'Confirmed');
INSERT INTO ticket (booking_id, passenger_id, flight_instance_id, seat_id, price, ticket_number)
VALUES (1,1,1,2,5000,'ETK000001');
