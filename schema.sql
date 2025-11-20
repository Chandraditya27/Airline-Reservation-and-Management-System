CREATE DATABASE IF NOT EXISTS airline;
USE airline;

-- Airports
CREATE TABLE airport (
  id INT AUTO_INCREMENT PRIMARY KEY,
  iata CHAR(3) UNIQUE NOT NULL,
  name VARCHAR(150) NOT NULL,
  city VARCHAR(100) NOT NULL,
  country VARCHAR(100),
  timezone VARCHAR(50)
);

CREATE TABLE airline (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(10) UNIQUE NOT NULL,
  name VARCHAR(150) NOT NULL
);

CREATE TABLE aircraft (
  id INT AUTO_INCREMENT PRIMARY KEY,
  registration VARCHAR(20) UNIQUE NOT NULL,
  model VARCHAR(100) NOT NULL,
  total_seats INT NOT NULL
);

CREATE TABLE seat (
  id INT AUTO_INCREMENT PRIMARY KEY,
  aircraft_id INT NOT NULL,
  seat_label VARCHAR(6) NOT NULL,
  cabin_class ENUM('Economy','Premium Economy','Business','First') DEFAULT 'Economy',
  is_window BOOLEAN DEFAULT FALSE,
  is_aisle BOOLEAN DEFAULT FALSE,
  UNIQUE (aircraft_id, seat_label),
  FOREIGN KEY (aircraft_id) REFERENCES aircraft(id) ON DELETE CASCADE
);

CREATE TABLE flight (
  id INT AUTO_INCREMENT PRIMARY KEY,
  airline_id INT,
  flight_number VARCHAR(10) NOT NULL,
  origin_airport_id INT NOT NULL,
  dest_airport_id INT NOT NULL,
  duration_minutes INT,
  aircraft_id INT,
  UNIQUE (flight_number),
  FOREIGN KEY (airline_id) REFERENCES airline(id),
  FOREIGN KEY (origin_airport_id) REFERENCES airport(id),
  FOREIGN KEY (dest_airport_id) REFERENCES airport(id),
  FOREIGN KEY (aircraft_id) REFERENCES aircraft(id)
);

CREATE TABLE flight_instance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  flight_id INT NOT NULL,
  departure_datetime DATETIME NOT NULL,
  arrival_datetime DATETIME NOT NULL,
  status ENUM('Scheduled','Boarding','Departed','Arrived','Cancelled','Delayed') DEFAULT 'Scheduled',
  gate VARCHAR(10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (flight_id) REFERENCES flight(id) ON DELETE CASCADE,
  INDEX (flight_id),
  INDEX (departure_datetime)
);

CREATE TABLE passenger (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  email VARCHAR(150),
  phone VARCHAR(30),
  passport_no VARCHAR(50),
  dob DATE
);

CREATE TABLE booking (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_ref VARCHAR(10) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  booked_by_passenger_id INT,
  total_amount DECIMAL(10,2) DEFAULT 0,
  status ENUM('Pending','Confirmed','Cancelled','Completed') DEFAULT 'Pending',
  FOREIGN KEY (booked_by_passenger_id) REFERENCES passenger(id)
);

CREATE TABLE ticket (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT NOT NULL,
  passenger_id INT NOT NULL,
  flight_instance_id INT NOT NULL,
  seat_id INT,
  fare_class ENUM('Saver','Standard','Flex','Business') DEFAULT 'Standard',
  ticket_status ENUM('Issued','CheckedIn','Boarded','Used','Cancelled') DEFAULT 'Issued',
  price DECIMAL(9,2) DEFAULT 0,
  ticket_number VARCHAR(20) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES booking(id) ON DELETE CASCADE,
  FOREIGN KEY (passenger_id) REFERENCES passenger(id),
  FOREIGN KEY (flight_instance_id) REFERENCES flight_instance(id) ON DELETE CASCADE,
  FOREIGN KEY (seat_id) REFERENCES seat(id)
);

CREATE TABLE seat_reservation (
  id INT AUTO_INCREMENT PRIMARY KEY,
  flight_instance_id INT NOT NULL,
  seat_id INT NOT NULL,
  ticket_id INT,
  reserved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  reserved_until DATETIME,
  status ENUM('Held','Confirmed','Released') DEFAULT 'Held',
  UNIQUE (flight_instance_id, seat_id),
  FOREIGN KEY (flight_instance_id) REFERENCES flight_instance(id) ON DELETE CASCADE,
  FOREIGN KEY (seat_id) REFERENCES seat(id)
);

CREATE TABLE payment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  method ENUM('Card','UPI','NetBanking','Cash','Wallet') DEFAULT 'Card',
  status ENUM('Initiated','Success','Failed','Refunded') DEFAULT 'Initiated',
  paid_at TIMESTAMP NULL,
  transaction_ref VARCHAR(100),
  FOREIGN KEY (booking_id) REFERENCES booking(id) ON DELETE CASCADE
);

CREATE TABLE crew (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120),
  role ENUM('Pilot','CoPilot','CabinCrew','Engineer') DEFAULT 'CabinCrew',
  employee_code VARCHAR(30) UNIQUE
);

CREATE TABLE flight_crew (
  id INT AUTO_INCREMENT PRIMARY KEY,
  flight_instance_id INT NOT NULL,
  crew_id INT NOT NULL,
  assigned_role VARCHAR(50),
  FOREIGN KEY (flight_instance_id) REFERENCES flight_instance(id) ON DELETE CASCADE,
  FOREIGN KEY (crew_id) REFERENCES crew(id)
);
