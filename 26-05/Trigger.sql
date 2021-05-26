CREATE FUNCTION update_function()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$BODY$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO employees VALUES (DEFAULT, new.name + 'NEW', new.surname + 'NEW');
    END IF;
    RETURN new;
END;
$BODY$;

CREATE TRIGGER update_trigger
    BEFORE UPDATE
    ON employees
EXECUTE PROCEDURE update_function();