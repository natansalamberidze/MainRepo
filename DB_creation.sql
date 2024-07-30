/*
Creating tables.
*/
create table KLIENTI(
KLIENTA_ID NUMBER PRIMARY KEY,
UZVARDS VARCHAR2(30),
VARDS VARCHAR2(30),
VECUMS NUMBER(3),
DZIMUMS_F NUMBER
);
create table PRECES(
PREC_ID NUMBER PRIMARY KEY,
CENA NUMBER(10,2),
PREC_NOS_F NUMBER
);
create table VEIKALI(
VEIKALA_ID NUMBER PRIMARY KEY,
VEIKALA_NOS VARCHAR2(30),
PILSETAS_F NUMBER
);
create table PILSETAS(
PILS_ID NUMBER PRIMARY KEY,
PILS_NOS VARCHAR2(30)
);
create table LAIKS(
 DATE_ID NUMBER PRIMARY  KEY,
 DATUMS NUMBER,
 GADS_F NUMBER
);
create table GADS(
GADS_ID NUMBER PRIMARY KEY
);
create table PASUTIJUMI (
PAS_ID NUMBER PRIMARY KEY,
F_PREC_ID NUMBER,
F_VEIK_ID NUMBER,
F_KLIENTA_ID NUMBER,
F_DATE_ID NUMBER,
PAS_DAUDZUMS NUMBER,
PAS_SAMAKSATS NUMBER(10,2)
);
create table PREC_NOS(
PREC_NOS_ID NUMBER PRIMARY KEY,
PREC_NOS VARCHAR2(30)
);
create table DZIMUMS(
DZIM_ID NUMBER PRIMARY KEY,
DZIMUMS VARCHAR2(20)
);
/*
Link all the necessary tables.
*/
ALTER TABLE LAIKS
ADD CONSTRAINT LAIKS_GADS_fk
FOREIGN KEY (GADS_F) REFERENCES GADS (GADS_ID);

ALTER TABLE KLIENTI
ADD CONSTRAINT KLIENTI_DZIM_fk
FOREIGN KEY (DZIMUMS_F) REFERENCES DZIMUMS (DZIM_ID);

ALTER TABLE PRECES
ADD CONSTRAINT PREC_PREC_NOS_fk
FOREIGN KEY (PREC_NOS_F) REFERENCES PREC_NOS (PREC_NOS_ID);

ALTER TABLE VEIKALI
ADD CONSTRAINT VEIK_PILS_fk
FOREIGN KEY (PILSETAS_F) REFERENCES PILSETAS (PILS_ID);

ALTER TABLE PASUTIJUMI
ADD CONSTRAINT PAS_PRECE_fk
FOREIGN KEY (F_PREC_ID) REFERENCES PRECES (PREC_ID)
ADD CONSTRAINT PAS_VEIK_fk
FOREIGN KEY (F_VEIK_ID) REFERENCES VEIKALI (VEIKALA_ID)
ADD CONSTRAINT PAS_KLIE_fk
FOREIGN KEY (F_KLIENTA_ID) REFERENCES KLIENTI (KLIENTA_ID)
ADD CONSTRAINT PAS_DATE_fk
FOREIGN KEY (F_DATE_ID) REFERENCES LAIKS (DATE_ID);
/*
Full fill information in the table.
*/
begin
    for i in 2000 .. 2023 loop
    insert into GADS values (i);
    end loop;
end;

insert into d_dzimums values (1,'Virietis');
insert into d_dzimums values (2,'Sieviete');

declare i number;
type MASIVE1 is varray(76) of varchar2(15);
masivs_pilsetas MASIVE1 := MASIVE1(
'Zilupe',
'Vi??ni', 'Vi?aka', 'Vies?te', 'Ainaži',
'Aizkraukle', 'Aizpute', 'Akn?ste', 'Aloja', 'Al?ksne', 'Ape',
'Auce', 'Baldone', 'Baloži', 'Balvi',
'Bauska', 'Broc?ni', 'C?sis', 'Cesvaine', 'Dagda', 'Daugavpils',
'Dobele', 'Durbe', 'Grobi?a', 'Gulbene',
'Ikš?ile', 'Il?kste', 'Jaunjelgava', 'J?kabpils', 'Jelgava', 'J?rmala',
'Kandava', 'K?rsava', '?egums', 'Kr?slava',
'Kuld?ga', 'Lielv?rde', 'Liep?ja', 'L?gatne', 'Limbaži', 'L?v?ni',
'Lub?na', 'Ludza', 'Madona', 'Mazsalaca',
'Ogre', 'Olaine', 'P?vilosta', 'Piltene', 'P?avi?as', 'Prei?i',
'Priekule', 'R?zekne', 'R?ga',
'R?jiena', 'Sabile', 'Salacgr?va', 'Salaspils','Saldus',
'Saulkrasti', 'Seda', 'Sigulda',
'Skrunda', 'Smiltene', 'Staicele', 'Stende', 'Stren?i',
'Subate', 'Talsi', 'Tukums',
'Valdem?rpils', 'Valka', 'Valmiera', 'Vangaži', 'Varak??ni',
'Ventspils');
begin
    for i in 1 .. 76 loop
    insert into pilsetas values(i,masivs_pilsetas(i));  
    end loop;
end;

declare i number;
begin
for i in 1 .. 10000 loop
        insert into prec_nos values (i, DBMS_RANDOM.string('U', TRUNC(DBMS_RANDOM.value(3,10))));  
    end loop;
end;

declare i number;
begin
for i in 1 .. 100000 loop
        insert into preces values (i, DBMS_RANDOM.value(0.50, 999.99), TRUNC(DBMS_RANDOM.value(1, 10001)));  
    end loop;
end;

declare i number;
begin
for i in 1 .. 1000 loop
        insert into veikali values (i, DBMS_RANDOM.string('U', 1) ||
    DBMS_RANDOM.string('L', TRUNC(DBMS_RANDOM.value(4,8))), TRUNC(DBMS_RANDOM.value(1, 77)));  
    end loop;
end;

declare
i number;
--V?riešu v?rdu nosaukumi
type MASIVE4 is varray(56) of varchar2(20);
masivs_vards_viriesu MASIVE4 := MASIVE4(
'Antons','Natans', 'Andrejs','Kirils','Roberts', 'Aivars',
'Maks', 'Dans', 'Romans', 'Arturs',
'Stepans','Valerijs', 'Ri?iks', 'Miša', 'Valentins', 'Kristaps',
'Lacis', 'Daniils', 'Sergejs', 'Eriks',
'Filips', 'Zigmunds', 'Aleksejs', 'Kostja', 'Alex', 'Viliams',
'Bruno', 'Deniss', 'Dmitrijs', 'Artjoms',
'Gints', 'Renars', 'Raivo', 'Ruslans', 'Viliams', 'Ilja',
'Arsenijs', 'Zahars', 'Jans', 'Janis',
'Ignats', 'Vlads', 'Georgijs', 'Peteris', 'Amirs', 'Emils',
'Rustams', 'Mihails', 'Egors', 'Matvejs',
'Vitalijs', 'Bogdans', 'Juris', 'Vadims', 'Savelijs', 'Boris');
--Sieviešu v?rdu nosaukumi
type MASIVE5 is varray(60) of varchar2(20);
masivs_vards_sieviesu MASIVE5 := MASIVE5(
'Marija','M?ra', 'Natali', 'Vlada','Gunta','Sintija', 'Dasha',
'Aida','Natasha','Vika','Anna','Dace',
'Agita', 'Sofija','Vaida', 'Luiza',
'Luize','Kira','Mona', 'Dina', 'Alina','Maiga',
'Laima', 'Linda','Krispa', 'Melanija', 
'Mira', 'Iga', 'Lora', 'Ieva',
'Alise', 'Koko', 'Manita', 'Darine', 'Erika',
'Laura','Nadežda', 'Vika', 'Sasha', 'Alla','Mara', 'Mina', 'Roza', 
'Kristina', 'Aljona','Olga', 'Andzela', 'Vera', 'Madona', 'Liene',
'Kristi','Avita', 'Ieva', 'Liesma', 'Alexandra', 'Karl?na');
--Uzv?rdi
type MASIVE6 is varray(10000) of varchar2(20);
masivs_uzvards MASIVE6 := MASIVE6();
--Dzimumi
type MASIVE7 is varray(2) of number(2);
masivs_dzimums MASIVE7 := MASIVE7(1,2);
begin
--Uzv?rdu sa?ener?šana mas?v?
for i in 1 .. 10000 loop
masivs_uzvards.extend;
masivs_uzvards(i) := DBMS_RANDOM.string('U', 1) ||
DBMS_RANDOM.string('L', TRUNC(DBMS_RANDOM.value(3,15)));
end loop;
for i in 1 .. 100000 loop
if masivs_dzimums(TRUNC(DBMS_RANDOM.value(1, 3))) = 2
then

insert into KLIENTI values(i, masivs_uzvards(TRUNC(DBMS_RANDOM.value(, 10000))),
masivs_vards_sieviesu(TRUNC(DBMS_RANDOM.value(1, 56))),
TRUNC(DBMS_RANDOM.value(18, 75)),
2);

else
insert into KLIENTI values(i,
masivs_uzvards(TRUNC(DBMS_RANDOM.value(1, 10000))),
masivs_vards_viriesu(TRUNC(DBMS_RANDOM.value(1, 56))),
TRUNC(DBMS_RANDOM.value(18, 75)),
1);
end if;
end loop;
end;

declare i number;
begin
for i in 1 .. 100000 loop
        insert into LAIKS values 
		(i, TRUNC(DBMS_RANDOM.value(1, 12)), TRUNC(DBMS_RANDOM.value(2000, 2023)));
    end loop;
end;

declare i number;
n number;
k number;
begin
for i in 1 .. 200000 loop
n := TRUNC(DBMS_RANDOM.value(1, 100001));
k := TRUNC(DBMS_RANDOM.value(1, 31));
    insert into PASUTIJUMI values (
		i,
		n,
		TRUNC(DBMS_RANDOM.value(1, 1001)),
        TRUNC(DBMS_RANDOM.value(1, 100001)),
		TRUNC(DBMS_RANDOM.value(1, 100001)),
        k,
		k * (SELECT preces.cena from preces WHERE preces.prec_id = n)
    );
    end loop;
end;
/*
let's check.
*/
/*
This query calculates the total amount spent by the customer.
*/
SELECT UZVARDS, VARDS, SUM(PAS_SAMAKSATS) 
FROM KLIENTI 
JOIN PASUTIJUMI  ON KLIENTA_ID = F_KLIENTA_ID
WHERE KLIENTA_ID = 777
GROUP BY UZVARDS, VARDS;
/*
This query lists the number of shops in each city.
*/
SELECT PILS_NOS , COUNT(VEIKALA_ID) as VEIKALA_ID
FROM PILSETAS 
JOIN VEIKALI  ON PILS_ID = PILSETAS_F
GROUP BY PILS_NOS;
/*
This query calculates the average number of shops in Riga.
*/
SELECT AVG(COUNT(V.VEIKALA_ID)) as Videja 
FROM PILSETAS P
JOIN VEIKALI V ON P.PILS_ID = V.PILSETAS_F
WHERE PILS_NOS = 'R?ga'
GROUP BY PILS_NOS;

/*
Select all.
*/
select * from pasutijumi p, klienti k, dzimums d, laiks l, 
preces pr, prec_nos nos, veikali v, pilsetas pil
where
p.F_klienta_ID = k.klienta_ID AND k.dzimums_f = d.dzim_ID 
AND p.f_date_ID = l.date_id  AND p.f_prec_id = pr.prec_id
AND pr.prec_nos_f = nos.prec_nos_id  
AND p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pil.pils_id
/*
1.Query.
*/
select l.gads_f, sum(pr.cena) as Preces_cenas_summa ,
sum(p.pas_daudzums) as Summa, sum(p.pas_samaksats) as Daudzums
from pasutijumi p, laiks l, preces pr 
where
p.f_date_ID = l.date_id 
AND 
p.f_prec_id = pr.prec_id
group by l.gads_f
order by l.gads_f desc
/*
2. Query.
*/
select d.dzimums, sum(p.pas_samaksats) as Summa, sum(p.pas_daudzums) as Daudzums
from pasutijumi p,  klienti k, dzimums d
where
p.f_klienta_ID = k.klienta_id 
and k.dzimums_f = d.dzim_id
group by d.dzimums
order by sum(p.pas_samaksats) desc
/*
3. Query.
*/
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi p, veikali v, pilsetas pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc
/*
4. Query.
*/
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi p, klienti k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc
/*
5. Query.
*/
select pils_nos, count(v.veikala_nos) as Veikala_Nosaukums
from pasutijumi p, laiks l, veikali v, pilsetas pils
where
p.f_date_ID = l.date_id 
AND p.f_veik_ID = v.veikala_id 
AND v.pilsetas_f = pils.pils_id
AND l.gads_f = 2005
group by pils_nos
/*
All B-tree indexes.
*/
CREATE INDEX idx_pasutijumi_date_id ON PASUTIJUMI(f_date_ID);

CREATE INDEX idx_pasutijumi_prec_id ON PASUTIJUMI(f_prec_id);

CREATE INDEX idx_laiks_gads_f ON LAIKS(gads_f);


CREATE INDEX idx_pasutijumi_veik_id ON PASUTIJUMI(f_veik_ID);

CREATE INDEX idx_veikali_pilsetas_f ON VEIKALI(pilsetas_f);

CREATE INDEX idx_veikali_veikala_nos ON VEIKALI(veikala_nos)

CREATE INDEX idx_klienti_klienta_id_vards ON KLIENTI(klienta_id, vards);
/*
All BitMap indexes.
*/
create BitMap index Bit_prec on PRECES(cena);

create BitMap index  Ind_Bit on PASUTIJUMI(VEIKALA_NOS)  
from pasutijumi p, veikali v
where
p.f_veik_ID = v.veikala_id;

create BitMap index  Ind_Bit_2 on PASUTIJUMI (k.vards)  
from pasutijumi p, klienti k 
where k.klienta_id = p.f_klienta_id;
/*
All materialized views.
*/
create materialized view GADS_MS
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select l.gads_f, sum(pr.cena) as Preces_cenas_summa ,
sum(p.pas_daudzums) as Summa, sum(p.pas_samaksats) as Daudzums
from pasutijumi p, laiks l, preces pr 
where
p.f_date_ID = l.date_id 
AND 
p.f_prec_id = pr.prec_id
group by l.gads_f
order by l.gads_f desc;

analyze table pasutijumi COMPUTE STATISTICS;
analyze table laiks COMPUTE STATISTICS;
analyze table preces COMPUTE STATISTICS;
alter session set OPTIMIZER_MODE = ALL_ROWS;


create materialized view VEIKALS_MS
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi p, veikali v, pilsetas pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc

analyze table pasutijumi COMPUTE STATISTICS;
analyze table veikali COMPUTE STATISTICS;
analyze table pilsetas COMPUTE STATISTICS;
alter session set OPTIMIZER_MODE = ALL_ROWS;


create materialized view VARDS_MS
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi p, klienti k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc

analyze table pasutijumi COMPUTE STATISTICS;
analyze table klienti COMPUTE STATISTICS;
alter session set OPTIMIZER_MODE = ALL_ROWS;
/*
Four dimensions created.
*/
CREATE dimension DIM_VEIKALI
level L_PIL is PILSETAS.PILS_NOS
level L_VEIK is VEIKALI.VEIKALA_NOS
hierarchy HIERARCHY_veikali(
L_VEIK child of 
L_PIL  
JOIN KEY(VEIKALI.pilsetas_f ) REFERENCES L_PIL)
ATTRIBUTE L_PIL DETERMINES PILSETAS.PILS_ID
ATTRIBUTE L_VEIK DETERMINES VEIKALI.VEIKALA_ID;


CREATE dimension DIM_PRECES
level L_PRNOS is PREC_NOS.prec_nos
level L_PRECES is PRECES.CENA
hierarchy HIERARCHY_preces(
L_PRECES child of 
L_PRNOS
JOIN KEY(PRECES.PREC_NOS_F ) REFERENCES L_PRNOS)
ATTRIBUTE L_PRECES DETERMINES PRECES.PREC_ID
ATTRIBUTE L_PRNOS DETERMINES PREC_NOS.PREC_NOS_ID;


CREATE dimension DIM_LAIKS
level L_GADS is GADS.GADS_ID
level L_DATE is LAIKS.DATUMS
hierarchy HIERARCHY_laiks(
L_DATE child of 
L_GADS
JOIN KEY(LAIKS.GADS_F) REFERENCES L_GADS )
ATTRIBUTE L_GADS DETERMINES GADS.GADS_ID
ATTRIBUTE L_DATE DETERMINES LAIKS.DATE_ID;


CREATE dimension DIM_Klienti
level L_DZIM is DZIMUMS.DZIMUMS
level L_KLT is KLIENTI.KLIENTA_ID
hierarchy HIERARCHY_klienti(
L_KLT child of 
L_DZIM
JOIN KEY(KLIENTI.DZIMUMS_F) REFERENCES L_DZIM)
ATTRIBUTE L_DZIM DETERMINES DZIMUMS.DZIM_ID
ATTRIBUTE L_KLT DETERMINES KLIENTI.KLIENTA_ID;
/*
Materialized view hierarchy.
*/
create materialized view MAT_SKATS_1
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select D1.vards v, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi p, klienti D1
where
p.f_klienta_ID = D1.klienta_id  
AND vards LIKE 'Ma%'
group by D1.vards
order by Summa desc;

create materialized view MAT_SKATS_1_1
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select v, SUM(Summa), SUM(Daudzums)
from MAT_SKATS_1 
group by v

create materialized view MAT_SKATS_2
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select v
from MAT_SKATS_1_1 
group by v
