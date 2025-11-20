DELIMITER //

CREATE PROCEDURE sp_book_seat(
  IN p_booking_ref VARCHAR(10),
  IN p_passenger_id INT,
  IN p_flight_instance_id INT,
  IN p_seat_id INT,
  IN p_price DECIMAL(9,2)
)
BEGIN
  DECLARE exit HANDLER FOR SQLEXCEPTION
  BEGIN
    -- rollback on error
    ROLLBACK;
    SELECT 'ERROR' AS status;
  END;

  START TRANSACTION;

  -- check seat is free (attempt to insert into seat_reservation)
  INSERT INTO seat_reservation (flight_instance_id, seat_id, status, reserved_until)
  VALUES (p_flight_instance_id, p_seat_id, 'Held', DATE_ADD(NOW(), INTERVAL 15 MINUTE));

  -- create booking
  INSERT INTO booking (booking_ref, booked_by_passenger_id, total_amount, status)
  VALUES (p_booking_ref, p_passenger_id, p_price, 'Confirmed');

  SET @booking_id = LAST_INSERT_ID();

  -- create ticket
  INSERT INTO ticket (booking_id, passenger_id, flight_instance_id, seat_id, price, ticket_number)
  VALUES (@booking_id, p_passenger_id, p_flight_instance_id, p_seat_id, p_price, CONCAT('ETK', LPAD(@booking_id,6,'0')));

  -- mark seat reservation confirmed and link ticket (optional)
  UPDATE seat_reservation
  SET status='Confirmed', ticket_id = LAST_INSERT_ID()
  WHERE flight_instance_id = p_flight_instance_id AND seat_id = p_seat_id;

  COMMIT;
  SELECT 'OK' AS status, @booking_id AS booking_id;
END;
//
DELIMITER ;

-- Example Call
CALL sp_book_seat('REF001', 1, 1, 2, 5000.00);

-- Example Views
-- View: passenger manifest for flight instance
CREATE VIEW v_manifest AS
SELECT fi.id AS flight_instance_id, f.flight_number, fi.departure_datetime, p.id AS passenger_id,
       p.first_name, p.last_name, t.seat_id, s.seat_label
FROM flight_instance fi
JOIN flight f ON f.id = fi.flight_id
JOIN ticket t ON t.flight_instance_id = fi.id
JOIN passenger p ON p.id = t.passenger_id
LEFT JOIN seat s ON s.id = t.seat_id;

-- Simple report: daily revenue
SELECT DATE(paid_at) AS day, SUM(amount) AS revenue
FROM payment
WHERE status='Success'
GROUP BY DATE(paid_at)
ORDER BY day DESC;

-- Triggers
DELIMITER //
CREATE TRIGGER trg_update_booking_total AFTER INSERT ON ticket
FOR EACH ROW
BEGIN
  UPDATE booking
  SET total_amount = (SELECT COALESCE(SUM(price),0) FROM ticket WHERE booking_id = NEW.booking_id)
  WHERE id = NEW.booking_id;
END;
//
DELIMITER ;


