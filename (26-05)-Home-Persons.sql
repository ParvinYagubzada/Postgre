-- noinspection SpellCheckingInspectionForFile

--  Task-1  --
CREATE TABLE persons
(
    id        int     NOT NULL,
    name      varchar NOT NULL,
    surname   varchar NOT NULL,
    birthdate date    NOT NULL
) PARTITION BY RANGE (birthdate);

CREATE TABLE persons_lesser PARTITION OF persons
    FOR VALUES FROM ('1753-01-01') TO ('1987.01.01');

CREATE TABLE persons_1987 PARTITION OF persons
    FOR VALUES FROM ('1987-01-01') TO ('1988.01.01');

CREATE TABLE persons_1988 PARTITION OF persons
    FOR VALUES FROM ('1988-01-01') TO ('1989.01.01');

CREATE TABLE persons_1989 PARTITION OF persons
    FOR VALUES FROM ('1989-01-01') TO ('1990.01.01');

CREATE TABLE persons_1990 PARTITION OF persons
    FOR VALUES FROM ('1990-01-01') TO ('1991.01.01');

CREATE TABLE persons_larger PARTITION OF persons
    FOR VALUES FROM ('1991-01-01') TO (current_date);

--  Task-2  --
CREATE TABLE persons_log
(
    id           serial NOT NULL
        CONSTRAINT persons_log_pk
            PRIMARY KEY,
    person_id    integer,
    name         varchar,
    surname      varchar,
    birthdate    varchar,
    trigger_date timestamp,
    type         varchar
);

--  Task-3  --
CREATE OR REPLACE FUNCTION trigger_function()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$body$
BEGIN
    IF (tg_op = 'INSERT') THEN
        INSERT INTO persons_log VALUES (DEFAULT, new.id, new.name, new.surname, new.birthdate, now(), 'I');
    ELSEIF (tg_op = 'DELETE') THEN
        INSERT INTO persons_log VALUES (DEFAULT, old.id, old.name, old.surname, old.birthdate, now(), 'D');
    ELSE
        INSERT INTO persons_log
        VALUES (DEFAULT, old.id,
                concat(old.name, '->', new.name),
                concat(old.surname, '->', new.surname),
                concat(old.birthdate, '->', new.birthdate),
                now(), 'U');
    END IF;
    RETURN new;
END;
$body$;

CREATE TRIGGER persons_trigger
    AFTER UPDATE OR DELETE OR INSERT
    ON persons
    FOR EACH ROW
EXECUTE FUNCTION trigger_function();

--  Task-4  --
CREATE SEQUENCE create_person_seq
    AS integer;

CREATE OR REPLACE PROCEDURE create_persons()
    LANGUAGE plpgsql
AS
$$
BEGIN
    FOR counter IN 1..500
        LOOP
            INSERT INTO persons
            VALUES (DEFAULT, 'Name-' || counter::text, 'Surname-' || counter::text,
                    '2010-01-01'::date - '1 day'::INTERVAL * round(random() * 365 * 40));
        END LOOP;
END;
$$;

TRUNCATE persons_log, persons RESTART IDENTITY;
CALL create_persons();

--  Task-5  --
CREATE OR REPLACE PROCEDURE update_persons()
    LANGUAGE plpgsql
AS
$body$
DECLARE
    num integer;
    random integer;
BEGIN
    FOR number IN 1..500 BY 3
        LOOP
            SELECT floor(random() * 3) INTO random;
            SELECT number + random INTO num;
            RAISE NOTICE 'num: % random: % star: % end: %', num, random, number, number + 2;
            UPDATE persons
            SET name = 'Updated'
            WHERE id = num;
        END LOOP;
END;
$body$;

CALL update_persons();
