/*
Tabulu veidošana.
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
Pec tabulas izveidošanas vajag ari izveidot dimensijas.
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
Parbaudisim DB buferi
*/
show parameter DB_BLOCK_SIZE;    
show parameter DB_BLOCK_BUFFERS;
/*
Parbaudim atminas resursu, vai tas ir vai nav izdalits.(Bufera izveidošana)
*/
show PARAMETER INMEMORY_SIZE;
/*
Apskatisim SGA maksim?lo apgabala izmeru kuru ir iespejams iedod sistemai un palielinam atminu.
*/
ALTER SYSTEM SET INMEMORY_SIZE=2G SCOPE=SPFILE;
/*
Talak ejam uz SQL Plus.Izsledzam datu bazi un palaidam to no jaunas ar komandam
*/
shutdown immediate;
Startup;
/*
Mes redzam kludu, jo no SGA_TARGET inicializacijas parametra iestatijuma tiek ateemts In-Memory apgabals, bet SGA_TARGET ir mazs. Vajag to palielin?t.
Pirmkart vajadzija izslegt datubazi un pec tam jau palielinat atminas vertibu x2. Ta bija autora kluda, tapec autoram bija jadoma ka to izlabot.
Ar komandu izveidojam PFILE kur mes varesim nomainit sga_target vertibu.
*/
CREATE PFILE = 'ORACLE_HOME_PATH' FROM SPFILE;
/*
Mana gadijuma
*/
CREATE PFILE = 'C:\BD_2023\dbs\custom_init.ora' FROM SPFILE
/*
Taja faila mainam sga_target vertibu uz 4G un saglabam.
*/
CREATE SPFILE FROM PFILE = 'ORACLE_HOME_PATH_TO_CREATED_PFILE';
/*
Mana gadijuma
*/
CREATE SPFILE FROM PFILE = 'C:\BD_2023\dbs\custom_init.ora';
/*
Datubaze tika veiksmigi starteta un ir redzams, ka In-Memory area izmers ir 2GB. To var ari parbaudit ar vaicajumu.
*/
SHOW PARAMETER INMEMORY_SIZE;
/*
Ir pienacis laiks parvietot tabulas operativaja atmina.
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
Rakstam vaicajumus originalaiem tabulam un In-Memory. 
Izpildam vaicajumu ar agregacijas funkciju:
*/
select /* +FULL(PASUTIJUMI_IM) NO_PARALLEL(PASUTIJUMI_IM)*/COUNT(*) from pasutijumi_im;
/*
Ir sasummeti visi ieraksti: Cena, Daudzums, Samaksa visiem veikaliem, visas pilsetas, katra gada no 2000-2023.
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
1.Vaicajums – atminas apgabala tabulai.
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
Ir ieguta inform?cija par samaksatu summu pasutijumiem un pasutijuma daudzumu, pa veikaliem kur, veikala  nosaukums sakas ar -Vu.
*/
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi p, veikali v, pilsetas pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc;
/*
2.Vaicajums – atminas apgabala tabulai.
*/
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi_im p, veikali_im v, pilsetas_im pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc;
/*
Ir ieguta informacija par samaksatu summu pasutijumiem, pa klientiem kur, klienta vards sakas ar -Ma.
*/
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi p, klienti k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc;
/*
3.Vaicajums – atminas apgabala tabulai.
*/
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi_im p, klienti_im k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc;
/*
1.Materializetais skats
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
1 skatu ieliksim atmina ar komandu.
*/
ALTER MATERIALIZED VIEW GADS_MS INMEMORY PRIORITY HIGH;
/*
2.Materializetais skats.
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
2 skatu ieliksim atmina ar komandu.
*/
ALTER MATERIALIZED VIEW VEIKALS_MS INMEMORY PRIORITY HIGH;
/*
3.Materializetais skats.
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
3 skatu ieliksim atmina ar komandu
*/
ALTER MATERIALIZED VIEW VEIKALS_MS INMEMORY PRIORITY HIGH;
/*
Rezultati ir pozitivi.
*/
