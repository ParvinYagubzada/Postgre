-- noinspection SpellCheckingInspectionForFile

INSERT INTO departments
VALUES (DEFAULT, 'IT');
INSERT INTO departments
VALUES (DEFAULT, 'Finance');

INSERT INTO employees
VALUES (default, 'Aslan', 'Salahov', 800, 1);
INSERT INTO employees
VALUES (default, 'Aygün', 'Kərimova', 1200, 1);
INSERT INTO employees
VALUES (default, 'Səidə', 'Dadaşova', 900, 1);
INSERT INTO employees
VALUES (default, 'Məmməd', 'Araz', 700, 2);
INSERT INTO employees
VALUES (default, 'Sənubər', 'Əliyeva', 300, 2);

SELECT departments.name, count(employees.id)
FROM employees
         RIGHT JOIN departments ON employees.department_id = departments.id AND employees.salary > 1000
GROUP BY departments.name;