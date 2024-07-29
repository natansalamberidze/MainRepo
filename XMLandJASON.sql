/*
Map? kur tiek glab?ti XML un XSD faili tika re?istr?ta k? direktorij?.
*/
CREATE OR REPLACE DIRECTORY XML_SCHEMA_DIR AS 'C:\Uni\XML';

DECLARE
  V_schema_library BFILE; 
  v_schema_projects BFILE;
BEGIN
  v_schema_library := BFILENAME('XML_SCHEMA_DIR', 'library.xsd'); 
  DBMS_XMLSCHEMA.registerSchema(
    SCHEMAURL => 'http://example.com/library.xsd',
    SCHEMADOC => v_schema_library,
    LOCAL     => TRUE,
    GENTYPES  => FALSE,
    GENTABLES => FALSE,
    OPTIONS   => 2,
    CSID => nls_charset_id('AL32UTF8')
    );

  v_schema_projects := BFILENAME('XML_SCHEMA_DIR', 'projects.xsd');
  DBMS_XMLSCHEMA.registerSchema(
    SCHEMAURL => 'http://example.com/projects.xsd',
    SCHEMADOC => v_schema_projects,
    LOCAL     => TRUE,
    GENTYPES  => FALSE,
    GENTABLES => FALSE,
    OPTIONS   => 2,
    CSID => nls_charset_id('AL32UTF8')
    ); 
END;
/*
P?rbaude.
*/
SELECT * FROM DBA_XML_SCHEMAS where schema_url like '%example%';
/*
Tika izveidotas divas bin?r?s glab?šanas XMLType tipa tabulas ar sh?mas izmantošanu.
*/
CREATE TABLE XML_BIN_TAB_BIBLIOTEKA of XMLType
    XMLSCHEMA "http://example.com/library.xsd"
    ELEMENT "biblioteka";
    
CREATE TABLE XML_BIN_TAB_PROJEKTI of XMLType
    XMLSCHEMA "http://example.com/projects.xsd"
    ELEMENT "uznemums";
/*
P?rbaude.
*/
select a.TABLE_NAME, a.XMLSCHEMA, a.STORAGE_TYPE
from USER_XML_TABLES a
where TABLE_NAME LIKE 'XML_BIN_TAB%';
/*
Lai ievietot XML failus tabul?s tika izveidota proced?ra.
*/
create or replace NONEDITIONABLE PROCEDURE ievietosanaXML_Kolonna( 
  p_dir IN VARCHAR2,
  p_filename IN VARCHAR2,
  p_table_name IN VARCHAR2
) AS
BEGIN

  BEGIN
   DBMS_XMLSCHEMA_UTIL.VALIDATE(
     XMLType(Bfilename(p_dir, p_filename), nls_charset_id ('AL32UTF8')),
     XMLType(Bfilename(p_dir, REPLACE(p_filename, '.xml', '.xsd')),nls_charset_id('AL32UTF8'))
    );
  EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
       DBMS_OUTPUT.PUT_LINE('Invalid XML document: ' || p_filename);
       RETURN;
  END;
  
  EXECUTE IMMEDIATE 'INSERT INTO '|| p_table_name || ' VALUES (XMLType(BFILENAME(:dir, :filename), nls_charset_id(''AL32UTF8'')))' 
   USING p_dir, p_filename;
   COMMIT;
END;

/*
Proced?ras palaišana.
*/
truncate table XML_BIN_TAB_BIBLIOTEKA; 
truncate table xml_bin_tab_projekti;

BEGIN
  ievietosanaXML_Kolonna('XML_SCHEMA_DIR', 'library.xml', 'XML_BIN_TAB_BIBLIOTEKA'); 
  ievietosanaXML_Kolonna('XML_SCHEMA_DIR', 'projects.xml', 'XML_BIN_TAB_PROJEKTI ');
END;
/*
P?rbaude
*/
select value(a) from XML_BIN_TAB_BIBLIOTEKA a;
select value(a) from xml_bin_tab_projekti a;
/*
No XML fail?, kas satur?ja inform?ciju par gr?mat?m ar XMLTable vaic?juma pal?dz?bu tika izg?ta inform?cija par gr?mat?m, kas ir latviešu valod? un kuram v?rt?jums ir liel?k par 4.5
*/
SELECT
  x.id,
  x.nosaukums,
  x.autors,
  x.izdosanas_gads,
  x.apraksts,
  x.vertejums
FROM
  XML_BIN_TAB BIBLIOTEKA,
  XMLTable('/biblioteka/gramata' PASSING OBJECT_VALUE
  COLUMNS
    id NUMBER PATH '@id',
    nosaukums VARCHAR2(100) PATH 'nosaukums',
    autors VARCHAR2(100) PATH 'autors',
    izdosanas_gads NUMBER PATH 'izdosanas_gads', 
    izdevuma_apskats XMLType PATH 'izdevuma_apskats', 
    izdevuma_valoda VARCHAR2(100) PATH'izdevuma_valoda', 
    vertejums NUMBER PATH 'izdevuma_apskats/vertejums', 
    apraksts VARCHAR2(100) PATH 'izdevuma apskats/apraksts'
    ) x
WHERE
x.vertejums > 4.5 AND x.izdevuma_valoda = 'Latviesu';
/*
No XML fail?, kas satur?ja inform?ciju par uz??muma projektiem ar XMLTable vaic?juma pal?dz?bu tika izg?ta inform?cija par projektu ilgumu gados un m?nešos.
*/
SELECT
  x.id,
  x.nosaukums,
  x.vaditajs,
  x.sakums,
  x.beigas,
  ROUND(MONTHS_BETWEEN(x.beigas, x.sakums), 2) AS projekta_ilgums_men, 
  ROUND(MONTHS_BETWEEN(x.beigas, x.sakums) / 12, 2) AS projekta_ilgums_gadi 
FROM
  xml_bin_tab projekti,
  XMLTable('/uznemums/projekts' PASSING OBJECT_VALUE
    COLUMNS
      id VARCHAR2(10) PATH '@id',
      nosaukums VARCHAR2(100) PATH 'nosaukums',
      vaditajs VARCHAR2(100) PATH 'vaditajs',
      sakums DATE PATH 'sakums',
      beigas DATE PATH 'beigas'
   ) x;
/*
No XML fail?, kas satur?ja inform?ciju par gr?mat?m ar XMLQuery vaic?juma pal?dz?bu tika izg?ta inform?cija par gr?matu izdošanas gadu un v?rt?jumiem.
*/
SELECT XMLQuery(
  'for $gramata in /biblioteka/gramata
  let $izdosanas_gads := $gramata/izdosanas_gads
  let $vertejums = $gramata/izdevuma_apskats/vertejums 
  return
     <GRAMATA>
          {$izdosanas_gads}
          {$vertejums}
     </GRAMATA>'
  PASSING OBJECT_VALUE RETURNING CONTENT
) AS REZULTATS
FROM XML_BIN_TAB_BIBLIOTEKA;
/*
No XML fail?, kas satur?ja inform?ciju par uz??muma projektiem ar XMLQuery vaic?juma pal?dz?bu tika izg?ta inform?cija par darbiniekiem, kas piedal?j?s jebkur? projekt?.
*/
SELECT
    XMLQuery(
      'for $i in /uznemums/projekts/dalibnieki 
      return $i/darbinieks'
      PASSING OBJECT_VALUE RETURNING content 
    ) as darbinieki
FROM xml_bin_tab_projekti;
/*
No XML fail?, kas satur?ja inform?ciju par gr?mat?m ar XMLCast vaic?juma pal?dz?bu tika izg?ta inform?cija par gr?matu vid?jo v?rt?jumu.
*/
SELECT AVG(XMLCast(XMLQuery('sum(/biblioteka/gramata/izdevuma_apskats/vertejums) div count (/biblioteka/gramata)' 
    PASSING OBJECT_VALUE RETURNING CONTENT) AS NUMBER)) AS AVG_VERTEJUMS
FROM XML_BIN_TAB_BIBLIOTEKA;
/*
No XML fail?, kas satur?ja inform?ciju par uz??muma projektiem ar XMLCast vaic?juma pal?dz?bu tika izg?ta inform?cija par visiem projekta vad?tajiem.
*/
SELECT XMLCast(XMLQuery('/uznemums/projekts/vaditajs' PASSING OBJECT_VALUE RETURNING CONTENT) AS VARCHAR2(100)) AS VADITAJA_VARDS 
FROM xml_bin_tab_projekti;
/*
XML datu par uz??muma projektu izvad?šana rel?ciju datu veid?.
*/
WITH
A AS (
  SELECT
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/nosaukums') AS Nosaukums,
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/vaditajs') AS Vaditajs,
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/sakums') AS Sakums,
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/beigas') AS Beigas,
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/@id') AS ProjektsID,
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/dalibnieki/darbinieks [1]/vards') AS DarbinieksVards1,
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/dalibnieki/darbinieks [1]/amats') AS DarbinieksAmatsl,
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/dalibnieki/darbinieks [1]/@id') AS DarbinieksID1, 
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/dalibnieki/darbinieks [2]/vards') AS DarbinieksVards2, 
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/dalibnieki/darbinieks [2]/amats') AS DarbinieksAmats2, 
    EXTRACTVALUE (OBJECT_VALUE, '/uznemums/projekts [1]/dalibnieki/darbinieks [2]/@id') AS DarbinieksID2
  FROM XML_BIN_TAB_PROJEKTI
)
SELECT
  Nosaukums,
  Vaditajs,
  Sakums,
  Beigas,
  ProjektsID,
  DarbinieksVards1,
  DarbinieksAmatsl,
  DarbinieksID1,
  DarbinieksVards2,
  DarbinieksAmats2,
  DarbinieksID2
FROM A;
/*
Rel?ciju datu izvad?šana XML datu form?t?(rel?ciju datu transform?šana XML datu form?t?).
Tabulas, kas satur?s rel?ciju datus par uz??muma projektiem, veidošana.
*/
CREATE TABLE PROJEKTI_R(
 PROJEKTS_ID      VARCHAR2(20),
 NOSAUKUMS        VARCHAR2(50),
 VADITAJS         VARCHAR2(50),
 SAKUMS           DATE,
 BEIGAS           DATE,
 DARBINIEKS_ID    VARCHAR2(20),
 DARBINIEKS_VARDS VARCHAR2(50),
 DARBINIEKS_AMATS VARCHAR2(50)
);
/*
Datu ievade tabul?.
*/
INSERT INTO PROJEKTI_R VALUES('P1001', 'Modernizacija', 'Laura Abolina', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), '1003', 'Maris Ozols', 'Programmetajs'); 
INSERT INTO PROJEKTI_R VALUES('P1001', 'Modernizacija', 'Laura Abolina', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), '1004', 'Liene Pumpure', 'Testetaja');
/*
XML datu ieg?šana.
*/
SELECT
  XMLSERIALIZE( 
     CONTENT
     xmlElement(
       "uznemums",
        xmlElement(
           "projekts",
           xmlAttributes (a. PROJEKTS_ID AS "id"),
           xmlElement("nosaukums", a.NOSAUKUMS),
           xmlElement("vaditajs", a.VADITAJS),
           xmlElement("sakums", TO_CHAR (a.SAKUMS, 'YYYY-MM-DD')), 
           xmlElement("beigas", TO_CHAR (a.BEIGAS, 'YYYY-MM-DD')),
           xmlElement(
              "dalibnieki", 
                 xmlElement(
                   "darbinieks",
                    xmlAttributes (a.DARBINIEKS_ID AS "id"), 
                    xmlElement("vards", a.DARBINIEKS_VARDS), 
                    xmlElement("amats", a.DARBINIEKS_AMATS)
                 )
             )
         )
       ) 
    INDENT SIZE = 2
 ) AS XML
FROM PROJEKTI_R a;
/*
Tabulu izveidošana JSON datu glab?šanai(tabulas defin?šana, datu ievade).
*/
create table j_biblioteka
 (id          VARCHAR2 (32) NOT NULL PRIMARY KEY,
  date_loaded TIMESTAMP (6) WITH TIME ZONE,
  po_document VARCHAR2 (23767)
  CONSTRAINT ensure_json_biblioteka CHECK (po_document is json));
  
create table j_projekti
 (id          VARCHAR2 (32) NOT NULL PRIMARY KEY,
  date_loaded TIMESTAMP (6) WITH TIME ZONE,
  po_document VARCHAR2 (23767)
  CONSTRAINT ensure_json_projekti CHECK (po_document is json));
/*
   insert into j_biblioteka values (SYS_GUID(), CURRENT_DATE, '
   [
  {
    "@id": "1",
    "nosaukums": "Ievads XML",
    "autors": "Janis Kalnins",
    "izdosanas_gads": "2020",
    "izdevuma_valoda": "Latviesu",
    "izdevuma veids": "Gramata",
    "izdevuma apskats": {
      "apraksts": "Si gramata piedava ieskatu XML pamatos un tas pielietojuma web izstrade.", 
      "vertejums": "4.5"
    }
   },
   {
*/
/*
    insert into j_projekti values (SYS_GUID(), CURRENT_DATE, '
    [
   {
     "@id": "P1001",
     "nosaukums": "Modernizacija",
     "vaditajs": "Laura Abolina",
     "sakums": "2022-03-01",
     "beigas": "2022-12-31",
     "dalibnieki": [
       {
        "@id": "1003",
        "vards": "Maris Ozols",
        "amats": "Programmetajs"
       },
       {
*/
/*
JSON_TABLE izmantošana.
*/
SELECT jt.nosaukums, jt.autors, jt.izdevuma_valoda, jt.vertejums 
FROM j_biblioteka a
CROSS JOIN JSON_TABLE(
    a.po_document,
    '$[*]'
    COLUMNS (
        nosaukums VARCHAR2(100) PATH '$.nosaukums',
        autors VARCHAR2(100) PATH '$.autors',
        izdevuma_valoda VARCHAR2(100) PATH '$.izdevuma_valoda', 
        vertejums NUMBER PATH '$.izdevuma_apskats.vertejums'
    )
) jt
WHERE jt.izdevuma_valoda = 'Latviesu'
  AND jt.vertejums > 4.5;
/*
JSON_QUERY izmantošana.
*/
SELECT JSON_QUERY (po_document,
                       '$.izdosanas_gads' WITH WRAPPER) as gads,
       JSON_QUERY(po_document,
                       '$.izdevuma_apskats.vertejums' WITH WRAPPER) as vert
FROM j_biblioteka;
/*
JSON_VALUE izmantošana.
*/
SELECT JSON_VALUE (po_document,
                       '$[3].izdevuma apskats.vertejums') as gads
FROM j_biblioteka;
