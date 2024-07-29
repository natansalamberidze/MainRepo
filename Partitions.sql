/*
Veidojam tabultelpas(tablespace).
*/
CREATE TABLESPACE tablespace_1
  DATAFILE 'df_1.dbf' SIZE 100M
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

CREATE TABLESPACE tablespace_2
  DATAFILE 'df_2.dbf' SIZE 100M
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

CREATE TABLESPACE tablespace_3
  DATAFILE 'df_3.dbf' SIZE 100M
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;
/*
Tabulu veidošana.
*/
CREATE TABLE customer(
    id NUMBER,
    name VARCHAR2(100),
    age NUMBER,
    phone_number VARCHAR2(20)
)tablespace tablespace_1;

CREATE TABLE payments(
    id NUMBER,
    user_id NUMBER,
    invoice_number VARCHAR2(200),
    payment_date DATE,
    amount NUMBER
)tablespace tablespace_2;
/*
Tabulu aizpild?šana.
*/
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
        INSERT INTO payments(id, user_id, invoice_number, payment_date, amount)
        VALUES (i,
                ROUND(DBMS_RANDOM.VALUE(1, 1000)),
                'Rekins - ' || TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1000000, 9999999))),
                SYSDATE - ROUND(DBMS_RANDOM.VALUE(1, 365)),
                ROUND(DBMS_RANDOM.VALUE(10, 1000), 2));
    END LOOP;
    
    COMMIT;
END;
/*
Defin?t tabulas ar:  diapazona sadal?juma part?cij?m, interv?la sadal?juma part?cij?m, heš funkcijas sadal?juma part?cij?m, saraksta sadal?juma part?cij?m un atsauces sadal?juma part?cij?m.
*/
CREATE TABLE payments_range_part
tablespace tablespace_3
PARTITION BY RANGE (amount)
(
    PARTITION part_1 VALUES LESS THAN (250),
    PARTITION part_2 VALUES LESS THAN (500),
    PARTITION part_3 VALUES LESS THAN (750),
    PARTITION part_4 VALUES LESS THAN (1001)
)
ENABLE ROW MOVEMENT
as (select * from payments);
/
CREATE TABLE payments_interval_part
PARTITION BY RANGE(amount) INTERVAL (250)
(partition amount1 values less than (250) tablespace tablespace_3)
ENABLE ROW MOVEMENT
as (select * from payments);
/
create table  payments_hash_part 
partition by HASH (amount)
partitions 4
as select * from payments;
/
CREATE TABLE payments_list_part
PARTITION BY LIST (amount)
(
    PARTITION part_1 VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 250),
    PARTITION part_2 VALUES (251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 500),
    PARTITION part_3 VALUES (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 750),
    PARTITION part_4 VALUES (751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 1000),
    PARTITION part_default values (DEFAULT)
)
as SELECT * from payments;
/
CREATE TABLE customer_range_part
tablespace tablespace_3
PARTITION BY RANGE (id)
(
    PARTITION part_1 VALUES LESS THAN (250),
    PARTITION part_2 VALUES LESS THAN (500),
    PARTITION part_3 VALUES LESS THAN (750),
    PARTITION part_4 VALUES LESS THAN (1001)
)
ENABLE ROW MOVEMENT
as (select * from customer);
/
alter table customer_range_part add constraint PK_CUST_ID PRIMARY KEY (id);
/
create table  payments_ref_part (
id, user_id not null, invoice_number, payment_date, amount,
constraint payment_cust_fk  foreign key(user_id) references customer_range_part(id))
partition by reference (payment_cust_fk)
ENABLE ROW MOVEMENT
as select * from payments;
/*
3 tipveida vaic?jumi.
*/
select AVG(Amount) from payments; --agreg?ts

select * from payments where amount < 155; -- ~15%

select * from payments where amount > 990; -- ~1%
/*
Nesadal?tai tabulai un sadal?t?m tabul?m veidojam lok?los un glob?los indeksus.
*/
CREATE INDEX idx_amount_global ON payments(amount); -- Indekss nesadal?tai tabulai.
/*
Indeksi sadal?tam tabulam.
*/
CREATE INDEX idx_amount_local_partition_1 ON payments_range_part(amount)LOCAL; -- Diapazonu

drop index idx_amount_local_partition_1;

CREATE INDEX idx_amount_global_part ON payments_range_part(amount);

/

CREATE INDEX idx_amount_local_interval ON payments_interval_part(amount) LOCAL; -- Intervalu.

drop index idx_amount_local_interval;

CREATE INDEX idx_amount_global_inetrval ON payments_interval_part(amount);

/

CREATE INDEX idx_amount_local_hash ON payments_hash_part(amount) LOCAL; -- Heš

drop index idx_amount_local_hash;

CREATE INDEX idx_amount_global_hash ON payments_hash_part(amount);

/

CREATE INDEX idx_id_local_list ON payments_list_part(amount) LOCAL; -- Sarakstu

drop index idx_id_local_list;

CREATE INDEX idx_id_global_list ON payments_list_part(amount);
/*
EXPLAIN PLAN.
*/
EXPLAIN PLAN FOR select AVG(Amount) from payments_list_part;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR select * from payments_list_part where amount < 155;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/
EXPLAIN PLAN FOR select * from payments_list_part where amount > 990;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
