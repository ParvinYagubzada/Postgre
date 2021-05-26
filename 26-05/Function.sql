CREATE OR REPLACE FUNCTION add(a int, b int)
    RETURNS int
    LANGUAGE plpgsql
AS
$result$
    DECLARE result int;
BEGIN
        SELECT a + b INTO result;
        RETURN result;
END;
$result$;


SELECT add(1, 3);
