/*
Veidojam nepieciešamus datu tipus.
*/
CREATE OR REPLACE TYPE pavari_type AS OBJECT(
pavara_id NUMBER,
vards VARCHAR2(20),
uzvards VARCHAR2(20),
vecums NUMBER(3,0)
);

CREATE OR REPLACE TYPE edieni_type AS OBJECT(
ediena_id NUMBER,
ediena_nos VARCHAR2(20),
ediena_cena NUMBER(3,0)
);

CREATE OR REPLACE TYPE edieni_ref_type AS object (
    ediena_ref ref edieni_type
);

CREATE OR REPLACE TYPE pavars_ref_type AS object (
    pavara_ref ref pavari_type
);

CREATE OR REPLACE TYPE pavari_kol_ref_type AS table of pavars_ref_type;

CREATE OR REPLACE TYPE edienii_kol_ref_type AS table of edieni_ref_type;

CREATE OR REPLACE TYPE restorans_type AS OBJECT (
    restorana_nos VARCHAR2(50),
    valsts VARCHAR2(20),
    pavari_list pavari_kol_ref_type,
    edieni_list edienii_kol_ref_type
);
/*
Veidojam tabulas.
*/
CREATE TABLE pavari OF pavari_type;
CREATE TABLE edieni OF edieni_type;
CREATE TABLE restorani OF restorans_type
nested table pavari_list store as pavari_ref_list
nested table edieni_list store as edieini_ref_list;
/*
Aizpild?m ?dienu un pavaru tabulas.
*/
INSERT INTO edieni VALUES (1, 'Pizza Margherita', 10);
INSERT INTO edieni VALUES (2, 'Chicken', 15);
INSERT INTO edieni VALUES (3, 'Caesar Salad', 8);
INSERT INTO edieni VALUES (4, 'Beef Burger', 12);
INSERT INTO edieni VALUES (5, 'Chocolate Brownie', 7);
INSERT INTO edieni VALUES (6, 'Cheeseburger', 7);
INSERT INTO edieni VALUES (7, 'Caprese Salad', 9);
INSERT INTO edieni VALUES (8, 'Spaghetti Bolognese', 14);
INSERT INTO edieni VALUES (9, 'Fish and Chips', 11);
INSERT INTO edieni VALUES (10, 'Vegetarian Pizza', 10);
INSERT INTO edieni VALUES (11, 'Cheesecake', 8);
INSERT INTO edieni VALUES (12, 'Mushroom Risotto', 13);
INSERT INTO edieni VALUES (13, 'Grilled Salmon', 16);
INSERT INTO edieni VALUES (14, 'Tiramisu', 9);
INSERT INTO edieni VALUES (15, 'Vegetable Stir-Fry', 12);
INSERT INTO edieni VALUES (16, 'Apple Pie', 7);


INSERT INTO pavari VALUES (1, 'J?nis', 'Ozols', 28);
INSERT INTO pavari VALUES (2, 'Inese', 'Liepi?a', 32);
INSERT INTO pavari VALUES (3, 'M?ris', 'Kalni?š', 25);
INSERT INTO pavari VALUES (4, 'L?ga', 'Lapi?a', 30);
INSERT INTO pavari VALUES (5, 'Andris', 'B?rzi?š', 34);
INSERT INTO pavari VALUES (6, 'Zane', 'Priede', 27);
INSERT INTO pavari VALUES (7, 'Agnese', 'Saul?te', 29);
INSERT INTO pavari VALUES (8, 'Juris', '?boli?š', 33);
INSERT INTO pavari VALUES (9, 'Laima', 'Ozola', 26);
INSERT INTO pavari VALUES (10, 'K?rlis', 'Liepa', 31);
INSERT INTO pavari VALUES (11, 'Dace', 'P?tersone', 35);
INSERT INTO pavari VALUES (12, 'Guntis', 'B?rzi?š', 28);
INSERT INTO pavari VALUES (13, 'Ilze', 'Kalni?a', 30);
INSERT INTO pavari VALUES (14, 'Edgars', 'Lapi?š', 32);
INSERT INTO pavari VALUES (15, 'Daina', 'Salmi?a', 27);
INSERT INTO pavari VALUES (16, 'Art?rs', 'Priedis', 29);
/*
Aizpildam restor?nu tabulas.
*/
INSERT INTO restorani VALUES ('Alfa Restor?ns', 'Latvija', 
    pavari_kol_ref_type(
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 1)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 2)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 3))
    ),
    edienii_kol_ref_type(
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 1)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 2)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 3))
    )
);

INSERT INTO restorani VALUES ('Beta Restor?ns', 'ASV', 
    pavari_kol_ref_type(
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 4)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 5)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 6))
    ),
    edienii_kol_ref_type(
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 4)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 5)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 6))
    )
);

INSERT INTO restorani VALUES ('Gamma Restor?ns', 'Japana', 
    pavari_kol_ref_type(
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 7)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 8)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 9))
    ),
    edienii_kol_ref_type(
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 7)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 8)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 9))
    )
);

INSERT INTO restorani VALUES ('Delta Restor?ns', 'Kina', 
    pavari_kol_ref_type(
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 10)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 11)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 12))
    ),
    edienii_kol_ref_type(
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 10)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 11)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 12))
    )
);

INSERT INTO restorani VALUES ('Fita Restor?ns', 'Igaunija', 
    pavari_kol_ref_type(
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 13)),
        pavars_ref_type((SELECT REF(p) FROM pavari p WHERE pavara_id = 14))
    ),
    edienii_kol_ref_type(
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 13)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 14)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 15)),
        edieni_ref_type((SELECT REF(e) FROM edieni e WHERE ediena_id = 16))
    )
);
/*
Kada ir vid?ja cena ?dienam restoran? ‘Fita Restor?ns’?
*/
select avg(deref(ediena_ref).ediena_cena)
FROM TABLE 
    (
        SELECT edieni_list
        FROM restorani
        WHERE restorana_nos = 'Fita Restor?ns'
    ) e
;
/*
Cik pavaru ir restor?n? ‘Fita Restor?ns’?
*/
select count(*)
FROM TABLE 
    (
        SELECT pavari_list
        FROM restorani
        WHERE restorana_nos = 'Fita Restor?ns'
    ) e
;
/*
Kads ir uzv?rds vec?kaj?m pavaram restor?na ‘Fita Restor?ns’ ?
*/
select deref(pavara_ref).uzvards, deref(pavara_ref).vecums
FROM TABLE
(
SELECT pavari_list
FROM restorani
WHERE restorana_nos = 'Fita Restor?ns'
) e
order by deref(pavara_ref).vecums desc
FETCH FIRST 1 ROWS ONLY;
/*
Izv?l?ties restor?nu ar visliel?ku ?dienu skaitu.
*/
select r.restorana_nos, r.valsts, Count(Value(b))
from restorani r, Table(r.edieni_list) b
group by r.restorana_nos, r.valsts
order by Count(Value(b)) desc
FETCH FIRST 1 ROWS ONLY;
/*
Izv?lieties darg?ko ?dienu starp visiem restor?niem.
*/
select r.restorana_nos, r.valsts, DEREF(Value(b).ediena_ref).ediena_nos , DEREF(Value(b).ediena_ref).ediena_cena
from restorani r, Table(r.edieni_list) b
ORDER BY DEREF(Value(b).ediena_ref).ediena_cena DESC
FETCH FIRST 1 ROWS ONLY;
