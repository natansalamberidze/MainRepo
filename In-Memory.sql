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
P?c tabulas izveidošanas vajag ar? izveidot dimensijas.
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
P?rbaud?sim DB buferi
*/
show parameter DB_BLOCK_SIZE;    
show parameter DB_BLOCK_BUFFERS;
/*
P?rbaud?m atmi?as resursu, vai tas ir vai nav izdal?ts.(Bufera izveidošana)
*/
show PARAMETER INMEMORY_SIZE;
/*
Apskat?sim SGA maksim?lo apgabala izm?ru kuru ir iesp?jams iedod sist?mai un palielin?m atmi?u.
*/
ALTER SYSTEM SET INMEMORY_SIZE=2G SCOPE=SPFILE;
/*
T?l?k ejam uz SQL Plus.Izsl?dzam datu b?zi un palaid?m to no jaunas ar komandam
*/
shutdown immediate;
Startup;
/*
M?s redzam k??du, jo no SGA_TARGET inicializ?cijas parametra iestat?juma tiek at?emts In-Memory apgabals, bet SGA_TARGET ir mazs. Vajag to palielin?t.
Pirmk?rt vajadz?ja izsl?gt datub?zi un p?c tam jau palielin?t atmi?as vert?bu x2. T? bija autora k??da, t?p?c autoram bija j?doma k? to izlabot.
Ar komandu izveidojam PFILE kur m?s var?sim nomain?t sga_target v?rt?bu.
*/
CREATE PFILE = 'ORACLE_HOME_PATH' FROM SPFILE;
/*
Man? gad?jum?
*/
CREATE PFILE = 'C:\BD_2023\dbs\custom_init.ora' FROM SPFILE
/*
Taj? fail? main?m sga_target v?rt?bu uz 4G un sagl?b?m.
*/
CREATE SPFILE FROM PFILE = 'ORACLE_HOME_PATH_TO_CREATED_PFILE';
/*
Man? gad?jum?
*/
CREATE SPFILE FROM PFILE = 'C:\BD_2023\dbs\custom_init.ora';
/*
Datub?ze tika veiksm?gi start?ta un ir redzams, ka In-Memory area izm?rs ir 2GB. To var ar? p?rbaud?t ar vaic?jumu 
*/
SHOW PARAMETER INMEMORY_SIZE;
/*
Ir pien?cis laiks p?rvietot tabulas operat?vaj? atmi??.
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
Rakstam vaic?jumus ori?in?laiem tabul?m un In-Memory. 
*/
/*
Izpild?m vaic?jumu ar agreg?cijas funkciju:
*/
select /* +FULL(PASUTIJUMI_IM) NO_PARALLEL(PASUTIJUMI_IM)*/COUNT(*) from pasutijumi_im;
/*
Ir sasumm?ti visi ieraksti: Cena, Daudzums, Samaksa visiem veikaliem, visas pils?tas, katr? gad? no 2000-2023.
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
1.Vaic?jums – atmi?as apgabala tabulai.
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
Ir ieg?ta inform?cija par samaks?tu summu pas?t?jumiem un pas?t?juma daudzumu, pa veikaliem kur, veikala  nosaukums s?kas ar -Vu
*/
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi p, veikali v, pilsetas pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc;
/*
2.Vaic?jums – atmi?as apgabala tabulai.
*/
select veikala_nos, sum(pas_samaksats) as Summa
from pasutijumi_im p, veikali_im v, pilsetas_im pils
where
p.f_veik_ID = v.veikala_id AND v.pilsetas_f = pils.pils_id 
AND v.veikala_nos LIKE 'Vu%'
group by veikala_nos
order by Summa desc;
/*
Ir ieg?ta inform?cija par samaks?tu summu pas?t?jumiem, pa klientiem kur, klienta v?rds s?kas ar -Ma
*/
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi p, klienti k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc;
/*
3.Vaic?jums – atmi?as apgabala tabulai.
*/
select vards, sum(pas_samaksats) as Summa, sum(pas_samaksats) as Daudzums
from pasutijumi_im p, klienti_im k
where
p.f_klienta_ID = k.klienta_id  
AND vards LIKE 'Ma%'
group by vards
order by Summa desc;
/*
1.Materializ?tais skats
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
1 skatu ieliksim atmi?? ar komandu
*/
ALTER MATERIALIZED VIEW GADS_MS INMEMORY PRIORITY HIGH;
/*
2.Materializ?tais skats
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
2 skatu ieliksim atmi?? ar komandu
*/
ALTER MATERIALIZED VIEW VEIKALS_MS INMEMORY PRIORITY HIGH;
/*
3.Materializ?tais skats
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
3 skatu ieliksim atmi?? ar komandu
*/
ALTER MATERIALIZED VIEW VEIKALS_MS INMEMORY PRIORITY HIGH;
/*
Rezult?ti ir pozit?vi.
*/