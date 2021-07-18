SELECT first.date,
       (SELECT sum(second.cash_flow)
       FROM cash second
       WHERE first.date >= second.date)
FROM cash first
ORDER BY date;

SELECT first.date, sum(second.cash_flow) FROM cash first
JOIN cash second
ON first.date >= second.date
GROUP BY first.date
ORDER BY date;