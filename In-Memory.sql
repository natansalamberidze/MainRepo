/*
Table creation.
*/
CREATE table DZIMUMS_IM as (SELECT * from DZIMUMS);
CREATE table KLIENTI_IM as (SELECT * from KLIENTI);
CREATE table GADS_IM as (SELECT * from GADS);
CREATE table LAIKS_IM as (SELECT * from LAIKS);
CREATE table PILSETAS_IM as (SELECT * from PILSETAS);
CREATE table PREC_NOS_IM as (SELECT * from PREC_NOS);
CREATE table PRECES_IM as (SELECT * from PRECES);
CREATE table VEIKALI_IM as (SELECT * from VEIKALI);
CREATE table PASUTIJUMI_IM as (SELECT * from PASUTIJUMI);
/*
Dimension creation.
*/
CREATE dimension DIM_VEIKALI_IM
level L_PIL_IM is PILSETAS_IM.PILS_NOS
level L_VEIK_IM is VEIKALI_IM.VEIKALA_NOS
hierarchy HIERARCHY_veikali_IM(
L_VEIK_IM child of 
L_PIL_IM 
JOIN KEY(VEIKALI_IM.pilsetas_f ) REFERENCES L_PIL_IM)
ATTRIBUTE L_PIL_IM DETERMINES PILSETAS_IM.PILS_ID
ATTRIBUTE L_VEIK_IM DETERMINES VEIKALI_IM.VEIKALA_ID;

CREATE dimension DIM_PRECES_IM
level L_PRNOS_IM is PREC_NOS_IM.prec_nos
level L_PRECES_IM is PRECES_IM.CENA
hierarchy HIERARCHY_preces_IM(
L_PRECES_IM child of 
L_PRNOS_IM 
JOIN KEY(PRECES_IM.PREC_NOS_F ) REFERENCES L_PRNOS_IM)
ATTRIBUTE L_PRECES_IM DETERMINES PRECES_IM.PREC_ID
ATTRIBUTE L_PRNOS_IM DETERMINES PREC_NOS_IM.PREC_NOS_ID;

CREATE dimension DIM_LAIKS_IM
level L_GADS_IM is GADS_IM.GADS_ID
level L_DATE_IM is LAIKS_IM.DATUMS
hierarchy HIERARCHY_laiks_IM(
L_DATE_IM child of 
L_GADS_IM
JOIN KEY(LAIKS_IM.GADS_F) REFERENCES L_GADS_IM)
ATTRIBUTE L_GADS_IM DETERMINES GADS_IM.GADS_ID
ATTRIBUTE L_DATE_IM DETERMINES LAIKS_IM.DATE_ID;

CREATE dimension DIM_Klienti_IM
level L_DZIM_IM is DZIMUMS_IM.DZIMUMS
level L_KLT_IM is KLIENTI_IM.KLIENTA_ID
hierarchy HIERARCHY_klienti_IM(
L_KLT_IM child of 
L_DZIM_IM
JOIN KEY(KLIENTI_IM.DZIMUMS_F) REFERENCES L_DZIM_IM)
ATTRIBUTE L_DZIM_IM DETERMINES DZIMUMS_IM.DZIM_ID
ATTRIBUTE L_KLT_IM DETERMINES KLIENTI_IM.KLIENTA_ID;

select DIMENSION_NAME 
from ALL_DIMENSIONS;

/*
Checking the DB buffer.
*/
show parameter DB_BLOCK_SIZE;    
show parameter DB_BLOCK_BUFFERS;
/*
Let's check the memory resource whether it is allocated or not. (Creating a buffer)
*/
show PARAMETER INMEMORY_SIZE;
/*
Let us consider the maximum area of the SGA that can be given to the system and the memory to be increased.
*/
ALTER SYSTEM SET INMEMORY_SIZE=2G SCOPE=SPFILE;
/*
So we're going to SQL Plus. We delete the database and restart it with the command.
*/
shutdown immediate;
Startup;
/*
We see a cludge because the SGA_TARGET initialization parameter is set to remove the In-Memory area, but SGA_TARGET is small. We need to increase it.
You should first load the database and then increase the memory value x2. This was the author's mistake, so the author should have known how to fix it.
With the command, we create a PFILE where we can change the value of sga_target.
*/
CREATE PFILE = 'ORACLE_HOME_PATH' FROM SPFILE;
/*
My case.
*/
CREATE PFILE = 'C:\BD_2023\dbs\custom_init.ora' FROM SPFILE
/*
Change the sga_target value in that file to 4G and save.
*/
CREATE SPFILE FROM PFILE = 'ORACLE_HOME_PATH_TO_CREATED_PFILE';
/*
My case.
*/
CREATE SPFILE FROM PFILE = 'C:\BD_2023\dbs\custom_init.ora';
/*
The database was successfully started and it can be seen that the In-Memory area is 2GB. You can also check it with a query.
*/
SHOW PARAMETER INMEMORY_SIZE;
/*
It is time to replace the operational memory of the tables.
*/
ALTER TABLE pasutijumi_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE dzimums_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE gads_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE klienti_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE laiks_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE pilsetas_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE prec_nos_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE preces_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
ALTER TABLE veikali_IM INMEMORY MEMCOMPRESS FOR CAPACITY LOW PRIORITY HIGH;
/*
Queries for the original table and In-Memory. Query with an aggregation function
*/
select /* +FULL(PASUTIJUMI_IM) NO_PARALLEL(PASUTIJUMI_IM)*/COUNT(*) from pasutijumi_im;
/*
All records are summed up: price, quantity, and payment for all shops, all cities, every year from 2000-2023.
*/
select l.gads_f, sum(pr.cena) as Preces_cenas_summa ,
sum(p.pas_daudzums) as Summa, sum(p.pas_samaksats) as Daudzums
from pasutijumi p, laiks l, preces pr 
where
p.f_date_ID = l.date_id 
AND 
p.f_prec_id = pr.prec_id
group by l.gads_f
order by l.gads_f desc;
/*
1. Query - for the memory area table.
*/
select l.gads_f, sum(pr.cena) as Preces_cenas_summa ,
sum(p.pas_daudzums) as Summa, sum(p.pas_samaksats) as Daudzums
from pasutijumi_im p, laiks_im l, preces_im pr 
where
p.f_date_ID = l.date_id 
AND 
p.f_prec_id = pr.prec_id
group by l.gads_f
order by l.gads_f desc;
/*
Information on the amount paid for transactions and the quantity of the transaction, by store, where the store name is -Vu.
*/
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi p, veikali v, pilsetas pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc;
/*
2. Query - for the memory area table.
*/
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi_im p, veikali_im v, pilsetas_im pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc;
/*
Information has been obtained on the amount paid for transactions, by a customer, where the customer's name is -Ma.
*/
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi p, klienti k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc;
/*
3. Query - for the memory area table.
*/
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi_im p, klienti_im k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc;
/*
The first Materialist view.
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
/*
Insert into first view In-Memory with command.
*/
ALTER MATERIALIZED VIEW GADS_MS INMEMORY PRIORITY HIGH;
/*
The second Materialist view.
*/
create materialized view VEIKALS_MS
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi p, veikali v, pilsetas pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc;
analyze table pasutijumi COMPUTE STATISTICS;
analyze table veikali COMPUTE STATISTICS;
analyze table pilsetas COMPUTE STATISTICS;
alter session set OPTIMIZER_MODE = ALL_ROWS;
/*
Insert into the second view In-Memory with the command.
*/
ALTER MATERIALIZED VIEW VEIKALS_MS INMEMORY PRIORITY HIGH;
/*
The Third Materialist View.
*/
create materialized view VARDS_MS
BUILD IMMEDIATE
ENABLE QUERY REWRITE as
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi p, klienti k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc;
analyze table pasutijumi COMPUTE STATISTICS;
analyze table klienti COMPUTE STATISTICS;
alter session set OPTIMIZER_MODE = ALL_ROWS;
/*
Insert into the third view In-Memory with the command.
*/
ALTER MATERIALIZED VIEW VEIKALS_MS INMEMORY PRIORITY HIGH;
