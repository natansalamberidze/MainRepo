/*
Creating two logically linked tables and filling them with data. One table has 1000 rows, the other has 100,000 rows.
*/
CREATE TABLE customer (
    id NUMBER,
    name VARCHAR2(100),
    age NUMBER,
    phone_number VARCHAR2(20)
)tablespace tablespace_1;

CREATE TABLE payments (
    id NUMBER,
    user_id NUMBER,
    invoice_number VARCHAR2(200),
    payment_date DATE,
    amount NUMBER
)tablespace tablespace_2;
/
DECLARE
    i NUMBER;
    TYPE name_array IS VARRAY(15) OF VARCHAR2(50);
    TYPE surname_array IS VARRAY(15) OF VARCHAR2(50);

    first_names name_array := name_array('J?nis', 'P?teris', 'M?ris', 'Andris', '?ris', 'Art?rs', 'Miks', 'Lauris', 'Ren?rs', 'Raimonds', 'Kristaps', 'Edgars', 'Juris', 'Rihards', 'Andris');
    surnames surname_array := surname_array('B?rzi?š', 'Liepi?š', 'Ozoli?š', 'Saul?tis', 'Kalni?š', '??ni?š', 'S?j?js', 'Pried?tis', 'V?tols', 'Liepa', 'Gulbis', 'Kr?mi?š', 'Muižnieks', 'L?sis', 'Šmits');
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO customer (id, name, age, phone_number)
        VALUES (i, 
                first_names(TRUNC(DBMS_RANDOM.VALUE(1, 15))) || ' ' || surnames(TRUNC(DBMS_RANDOM.VALUE(1, 15))),
                ROUND(DBMS_RANDOM.VALUE(18, 80)),
                TO_CHAR('+3712' || ROUND(DBMS_RANDOM.VALUE(1000000, 9999999)))
                );
    END LOOP;

    FOR i IN 1..100000 LOOP
        INSERT INTO payments (id, user_id, invoice_number, payment_date, amount)
        VALUES (i,
                ROUND(DBMS_RANDOM.VALUE(1, 1000)),
                'Rekins - ' || TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1000000, 9999999))),
                SYSDATE - ROUND(DBMS_RANDOM.VALUE(1, 365)),
                ROUND(DBMS_RANDOM.VALUE(10, 1000), 2));
    END LOOP;
    
    COMMIT;
END;
/*
Define 3 queries to one table. ORDER BY, GROUP BY, HAVING, and aggregate clauses must be used in the queries.
*/
/*
ORDER BY and GROUP BY with an aggregate function.
*/
SELECT age, COUNT(*) AS customer_count
FROM customer
GROUP BY age
ORDER BY age;
/*
HAVING with GROUP BY and aggregate function.
*/
SELECT age, COUNT(*) AS customer_count
FROM customer
GROUP BY age
HAVING COUNT(*) > 2;
/*
ORDER BY with aggregate function.
*/
SELECT id, name, age
FROM customer
ORDER BY age DESC;
/*
Define 3 queries for related tables. ORDER BY, GROUP BY, HAVING, and aggregate clauses must be used in the queries.
*/
/*
ORDER BY and GROUP BY with aggregate function (using combined data from both tables).
*/
SELECT c.name, SUM(p.amount) AS total_payments
FROM payments p
JOIN customer c ON p.user_id = c.id
GROUP BY c.name
ORDER BY total_payments DESC;
/*
HAVING with GROUP BY and aggregate function (using merged data from both tables).
*/
SELECT c.name, COUNT(*) AS payment_count
FROM payments p
JOIN customer c ON p.user_id = c.id
GROUP BY c.name
HAVING COUNT(*) > 5;
/*
ORDER BY with aggregate function (using combined data from both tables).
*/
SELECT c.name, p.payment_date, p.amount
FROM payments p
JOIN customer c ON p.user_id = c.id
ORDER BY p.payment_date DESC;
/*
When using execution parallel servers (specifying the degree of parallelism), make sure that they produce a better result.
*/
EXPLAIN PLAN FOR SELECT /*+ NO_PARALLEL(p) */ AVG(amount) FROM payments p;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 4) */ AVG(amount) FROM payments p;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 8) */ AVG(amount) FROM payments p;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/*
Execute queries with parallel servers and obtain the query execution plan
*/
/*
3 queries to one table.
*/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 8) */ age, COUNT(*) AS customer_count
FROM customer
GROUP BY age
ORDER BY age;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 8) */ age, COUNT(*) AS customer_count
FROM customer
GROUP BY age
HAVING COUNT(*) > 2;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 8) */ id, name, age
FROM customer
ORDER BY age DESC;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/*
3 queries for related tables.
*/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 8) */ c.name, SUM(p.amount) AS total_payments
FROM payments p
JOIN customer c ON p.user_id = c.id
GROUP BY c.name
ORDER BY total_payments DESC;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 8) */ c.name, COUNT(*) AS payment_count
FROM payments p
JOIN customer c ON p.user_id = c.id
GROUP BY c.name
HAVING COUNT(*) > 5;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR SELECT /*+ PARALLEL(p, 8) */ c.name, p.payment_date, p.amount
FROM payments p
JOIN customer c ON p.user_id = c.id
ORDER BY p.payment_date DESC;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
