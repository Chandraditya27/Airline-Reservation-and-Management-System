# Airline-Reservation-and-Management-System

**A complete SQL-first backend project** demonstrating a normalized relational schema, sample data, ER diagram, Dockerized MySQL, and a minimal REST API skeleton (Node.js + Express). Ideal for GitHub portfolio / interviews.

## Contents
- `sql/schema.sql` — Database DDL (tables, constraints, indexes, triggers)
- `sql/sample_data.sql` — Seed/sample rows

## Features
- Normalized schema for flights, flight instances, aircraft, seats, bookings, tickets, payments, crew.
- Seat hold/reservation flow to avoid double-booking.
- Sample stored procedure for atomic booking.

##Useful SQL Commands
mysql -u root -p < sql/schema.sql
mysql -u root -p < sql/sample_data.sql
