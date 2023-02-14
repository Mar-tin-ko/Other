-- Solving the detective case in 50_ville (CS50x lab) using VSCode (SQLite) and PHPLiteAdmin
USE 50_ville;

-- Check crime scene description according to crime date and street
SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = "Humphrey Street";

-- Check interviews of witnesses
SELECT transcript FROM interviews WHERE month = 7 AND day = 28;

-- Check security logs from bakery to get licence plates of suspisous people
SELECT license_plate FROM bakery_security_logs
    WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25;

-- Find personal details of the suspicious people
SELECT license_plate, id, name, phone_number, passport_number FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25);

-- Check the ATM logs on Leggett Str. to get list of suspicious bank acounts of the potential thief
SELECT account_number, amount FROM atm_transactions
    WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street";

-- Find person IDs for the suspicious bank accounts of the potencial thief
SELECT DISTINCT bank_accounts.account_number, bank_accounts.person_id FROM bank_accounts
    JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
        WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street");

-- Find person IDs for the suspicious bank accounts of the potencial thief
SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
    JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
        WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street");

-- Find the personal details of the potencial thief based on the suspicious bank accounts
SELECT id, name, phone_number, passport_number, license_plate  FROM people WHERE id IN (
    SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
        WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"));

-- Find intersection of the suspicious owners of the license plates and the suspicious bank acounts
SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25);

-- List phone numbers of people with suspicious license plates
SELECT phone_number FROM people
        WHERE license_plate IN
        (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25);

-- Who did the thief called?
SELECT caller, receiver, duration FROM phone_calls
    WHERE caller IN
    (SELECT phone_number FROM people
        WHERE license_plate IN
        (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25));

-- What phone numbers did the suspucious people based on the license plate called for less than 1 minute?
SELECT caller, receiver, duration FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60;

-- What names did the suspicious people based on the license plate called for less than 1 minute?
SELECT name FROM people
    WHERE phone_number  IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60);

-- Intersection of the suspiscous people
SELECT name FROM people
    WHERE phone_number  IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT


SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25);

-- Find personal details of the person that the thief called for less than 1 minute
SELECT id, name, passport_number, license_plate FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number  IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25));

-- Find the flight_id of the thief
SELECT flight_id FROM passengers
    WHERE passport_number = (SELECT passport_number FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number  IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25)));

-- Find the flight details of the thief
SELECT DISTINCT flights.id, origin_airport_id, destination_airport_id FROM flights
    JOIN passengers ON flights.id = passengers.flight_id
        WHERE flights.month = 7 AND flights.day = 29 AND flights.id = (SELECT flight_id FROM passengers
    WHERE passport_number = (SELECT passport_number FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number  IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))));

-- Find the destination of the thief
SELECT DISTINCT airports.id, airports.full_name, airports.city FROM airports
JOIN flights ON airports.id = flights.destination_airport_id
    WHERE flights.destination_airport_id = (SELECT DISTINCT destination_airport_id FROM flights
    JOIN passengers ON flights.id = passengers.flight_id
        WHERE flights.month = 7 AND flights.day = 29 AND flights.id = (SELECT flight_id FROM passengers
            WHERE passport_number = (SELECT passport_number FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number  IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25)))));

-- Who did Bruce called for less than 1 min?
    SELECT phone_number FROM people
    WHERE name = (SELECT name FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25)));

-- Who did the thief called for less than 1 min?
SELECT caller, receiver, duration FROM phone_calls
    WHERE caller = (SELECT phone_number FROM people
    WHERE name = (SELECT name FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))))

AND month = 7 AND day = 28 AND duration < 60;

 -- Who is the acomplice?
 SELECT receiver FROM phone_calls
    WHERE caller = (SELECT phone_number FROM people
    WHERE name = (SELECT name FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))))

AND month = 7 AND day = 28 AND duration < 60;

-- What is the name of the acomplice?
SELECT name FROM people
    WHERE phone_number = ( SELECT receiver FROM phone_calls
    WHERE caller = (SELECT phone_number FROM people
    WHERE name = (SELECT name FROM people
    WHERE name  = (SELECT name FROM people
    WHERE phone_number IN (SELECT caller FROM phone_calls
    WHERE caller IN (SELECT phone_number FROM people
        WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
            WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))
    AND duration < 60)

INTERSECT

SELECT name FROM people
    WHERE id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts
        JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
            WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
                WHERE transaction_type = "withdraw" AND month = 7 AND day = 28 AND atm_location  = "Leggett Street"))

INTERSECT

SELECT name FROM people
    WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
        WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25))))

AND month = 7 AND day = 28 AND duration < 60);