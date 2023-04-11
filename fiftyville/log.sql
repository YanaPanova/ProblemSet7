-- Ведіть журнал будь-яких SQL-запитів, які ви виконуєте під час розгадування таємниці.

-- Перевірка опису злочину, який стався у вказаному місці та час.
SELECT description FROM crime_scene_reports
WHERE year = 2021 AND month = 7 AND day = 28 AND street = 'Humphrey Street';


-- Того дня сталося два випадки. Лише один пов’язаний із крадіжкою. Інше пов’язане зі сміттям.


-- Співучасником могли бути свідки. Отже, пошук імен свідків із таблиці допитів, перевіримо стенограми їхніх інтерв’ю.
SELECT name, transcript FROM interviews
WHERE year = 2021 AND month = 7 AND day = 28;


-- Знайдено дві розшифровки з іменем Eugene, тому перевіримо, скільки Eugene присутні в таблиці «люди».
SELECT name FROM people
WHERE name = 'Eugene';

-- З'ясувано, що Eugene один.


-- З’ясовано імена 3 свідків зі списку осіб, які давали інтерв’ю 28 липня 2021 року.
-- У протоколі про злочин свідки згадували «bakery». Також упорядкування результатів за алфавітом імен свідків.
SELECT name, transcript FROM interviews
WHERE year = 2021 AND month = 7 AND day = 28 AND transcript LIKE '%bakery%'
ORDER BY name;
-- Свідками є Eugene, Raymond, and Ruth.


-- Євген дав підказки. Злодій знімав гроші в банкоматі на вулиці Leggett. Отже, перевірка номера рахунку особи, яка здійснила цю операцію.
SELECT account_number, amount FROM atm_transactions
WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street'AND transaction_type = 'withdraw';


-- Пошук імен, пов’язаних із відповідними номерами рахунків. Внесення цих імен до «Списку підозрюваних»
SELECT name, atm_transactions.amount FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
WHERE atm_transactions.year = 2021
   AND atm_transactions.month = 7
   AND atm_transactions.day = 28
   AND atm_transactions.atm_location = 'Leggett Street'
   AND atm_transactions.transaction_type = 'withdraw';


-- Раймонд дав підказки:

-- Виходячи з пекарні, вони подзвонили людині та розмовляли менше хвилини. Вони попросили людину на іншому кінці розмови купити квиток на найраніший рейс 29 липня 2021 року.
-- Спочатку знайшли інформацію про аеропорт у Fiftyville, звідки мав би втекти злодій.
SELECT abbreviation, full_name, city FROM airports
WHERE city = 'Fiftyville';

-- Пошук рейсів на 29 липня з аеропорту Fiftyville та впорядкування їх за часом.

SELECT flights.id, full_name, city, flights.hour, flights.minute FROM airports
JOIN flights ON airports.id = flights.destination_airport_id
WHERE flights.origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville')
   AND flights.year = 2021
   AND flights.month = 7
   AND flights.day = 29
ORDER BY flights.hour, flights.minute;


-- Перший рейс буде о 8:20 до аеропорту LaGuardia в New York City.

-- Перевірка списку пасажирів цього рейсу. Внести їх усіх до «Списку підозрюваних». Впорядкування імен за номерами паспортів.
SELECT passengers.flight_id, name, passengers.passport_number, passengers.seat FROM people
JOIN passengers ON people.passport_number = passengers.passport_number
JOIN flights ON passengers.flight_id = flights.id
WHERE flights.year = 2021
   AND flights.month = 7
   AND flights.day = 29
   AND flights.hour = 8
   AND flights.minute = 20
ORDER BY passengers.passport_number;


-- Перевірка записів телефонних дзвінків, щоб знайти особу, яка купила квитки.

-- По-перше, перевірка можливих імен абонента та внесення цих імен до «Списку підозрілих». Упорядкування їх за тривалістю дзвінків.
SELECT name, phone_calls.duration FROM people
JOIN phone_calls ON people.phone_number = phone_calls.caller
WHERE phone_calls.year = 2021
   AND phone_calls.month = 7
   AND phone_calls.day = 28
   AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;

-- По-друге, перевірка можливих імен абонента-приймача. Упорядкування їх за тривалістю дзвінків.
SELECT name, phone_calls.duration FROM people
JOIN phone_calls ON people.phone_number = phone_calls.receiver
WHERE phone_calls.year = 2021
   AND phone_calls.month = 7
   AND phone_calls.day = 28
   AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;


-- Рут дала підказки:

-- Злодій поїхав на машині від пекарні протягом 10 хвилин після крадіжки.
-- ОТЖЕ, перевірка номерних знаків автомобілів протягом цього терміну. Потім перевірити імена власників цих автомобілів.

SELECT name, bakery_security_logs.hour, bakery_security_logs.minute FROM people
JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
WHERE bakery_security_logs.year = 2021
   AND bakery_security_logs.month = 7
   AND bakery_security_logs.day = 28
   AND bakery_security_logs.activity = 'exit'
   AND bakery_security_logs.hour = 10
   AND bakery_security_logs.minute >= 15
   AND bakery_security_logs.minute <= 25
ORDER BY bakery_security_logs.minute;
