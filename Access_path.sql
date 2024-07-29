/*
Divu savstarp?ji saist?tu pamattabulu ar 5 vai 6 kolon?m defin?šana.
*/
CREATE TABLE PD1_Clients (
    ClientID NUMBER PRIMARY KEY,
    ClientName VARCHAR2(100),
    Industry VARCHAR2(100),
    Discount INTEGER,
    City VARCHAR2(100)
);
/
drop table PD1_Clients;
/
CREATE TABLE PD1_Orders (
    OrderID NUMBER PRIMARY KEY,
    ClientID NUMBER,
    OrderDate DATE,
    DeliveryDate DATE,
    TotalAmount NUMBER,
    FOREIGN KEY (ClientID) REFERENCES PD1_Clients(ClientID)
);
/*
Divu savstarp?ji saist?tu pamattabulu aizpild?šana.
*/
DECLARE
    i NUMBER;
    j NUMBER;
order_date DATE;
    TYPE name_array IS VARRAY(15) OF VARCHAR2(50);
    TYPE surname_array IS VARRAY(15) OF VARCHAR2(50);
    TYPE industry_array IS VARRAY(5) OF VARCHAR2(50);
    TYPE city_array IS VARRAY(5) OF VARCHAR2(50);
    first_names name_array := name_array('J?nis', 'P?teris', 'M?ris', 'Andris', '?ris', 'Art?rs', 'Miks', 'Lauris', 'Ren?rs', 'Raimonds', 'Kristaps', 'Edgars', 'Juris', 'Rihards', 'Andris');
    surnames surname_array := surname_array('B?rzi?š', 'Liepi?š', 'Ozoli?š', 'Saul?tis', 'Kalni?š', '??ni?š', 'S?j?js', 'Pried?tis', 'V?tols', 'Liepa', 'Gulbis', 'Kr?mi?š', 'Muižnieks', 'L?sis', 'Šmits');
    industries industry_array := industry_array('Tehnolo?ijas', 'Finanses', 'Tirdzniec?ba', 'Izgl?t?ba', 'Vesel?bas apr?pe');
    cities city_array := city_array('R?ga', 'J?rmala', 'Liep?ja', 'Ventspils', 'Daugavpils');
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO PD1_Clients(ClientID, ClientName, Industry, Discount, City)
        VALUES (
            i, 
            first_names(TRUNC(DBMS_RANDOM.VALUE(1, 15))) || ' ' || surnames(TRUNC(DBMS_RANDOM.VALUE(1, 15))),
            industries(TRUNC(DBMS_RANDOM.VALUE(1, 5))),
            ROUND(DBMS_RANDOM.VALUE(0, 30)),
            cities(TRUNC(DBMS_RANDOM.VALUE(1, 5)))
        );
    END LOOP;
    FOR j IN 1..100000 LOOP
        order_date := SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 365));
        INSERT INTO PD1_Orders(OrderID, ClientID, OrderDate, DeliveryDate, TotalAmount)
        VALUES (
            j, 
            TRUNC(DBMS_RANDOM.VALUE(1, 1000)),
            order_date, 
            order_date + TRUNC(DBMS_RANDOM.VALUE(1, 30)),
            ROUND(DBMS_RANDOM.VALUE(100, 10000))
        );
    END LOOP;
    COMMIT;
END;
/*
Pilna tabulas sken?šana.
*/
SELECT * FROM PD1_Clients;
SELECT * FROM PD1_Orders;
/*
Veidojam indeksus.
*/
CREATE INDEX idx_client_city ON PD1_Clients(City);
CREATE INDEX idx_order_total ON PD1_Orders(TotalAmount);
/*
Indeksa diapazona sken?šana.
*/
SELECT /*+ INDEX(c idx_client_city) */ * FROM PD1_Clients c WHERE City BETWEEN 'A' AND 'M';
SELECT * FROM PD1_Orders WHERE TotalAmount BETWEEN 100 AND 10000;
/*
Savienojuma (Joins) metodes. Ligzdotas Cilpas Savienojums(Nested Loops).
*/
SELECT /*+ USE_NL(c o) */ * FROM PD1_Clients c JOIN PD1_Orders o ON c.ClientID = o.ClientID;
/*
Heš Savienojums(Hash Join).
*/
SELECT /*+ USE_HASH(c o) */ * FROM PD1_Clients c JOIN PD1_Orders o ON c.ClientID = o.ClientID;
/*
Š?irošanas un Sapludin?šanas Savienojums(Sort Merge Join).
*/
SELECT /*+ USE_MERGE(c o) */ * FROM PD1_Clients c JOIN PD1_Orders o ON c.ClientID = o
