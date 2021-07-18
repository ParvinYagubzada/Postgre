CREATE OR REPLACE FUNCTION populate_user_requests_function()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$BODY$
DECLARE
    row record;
BEGIN
    IF (TG_OP = 'INSERT') THEN
        FOR row IN SELECT username, company_name FROM users
            LOOP
                INSERT INTO user_requests
                VALUES (row.company_name, row.username,
                        new.uuid, FALSE, 0, NULL, NULL, NULL);
            END LOOP;
    END IF;
    RETURN new;
END;
$BODY$;

CREATE TRIGGER populate_user_requests_trigger
    AFTER INSERT
    ON requests
FOR EACH ROW EXECUTE PROCEDURE populate_user_requests_function();