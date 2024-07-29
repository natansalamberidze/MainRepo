/*
Vispirms veidojam relaciju tabulas.
*/
CREATE TABLE Autors (
  autora_id NUMBER PRIMARY KEY,
  vards VARCHAR2(50),
  uzvards VARCHAR2(50),
  dzimis DATE,
  valsts VARCHAR2(50)
);
CREATE TABLE Gramata (
  gramata_id NUMBER PRIMARY KEY,
  nosaukums VARCHAR2(100),
  izdevuma_gads NUMBER,
  autora_id NUMBER,
  FOREIGN KEY (autora_id) REFERENCES Autors(autora_id)
);
/*
Pec tam veidojam objektu tipus un objektu-relaciju tabulas.
*/
CREATE OR REPLACE TYPE Autors_Type AS OBJECT (
  autora_id NUMBER,
  vards VARCHAR2(50),
  uzvards VARCHAR2(50),
  dzimis DATE,
  valsts VARCHAR2(50)
);

CREATE OR REPLACE TYPE Gramata_Type AS OBJECT (
  gramata_id NUMBER,
  nosaukums VARCHAR2(100),
  izdevuma_gads NUMBER
);

CREATE OR REPLACE TYPE GramatuKolekcija_Type AS TABLE OF Gramata_Type;

CREATE OR REPLACE TYPE AutorsGramatas_Type AS OBJECT (autors Autors_Type,gramatas GramatuKolekcija_Type);

CREATE TABLE AutorsGramatas OF AutorsGramatas_Type NESTED TABLE gramatas STORE AS GramatuKolekcijaStorage;
/*
Aizpildam abu tipu tabulas.
*/
DECLARE
  v_gramata_counter NUMBER := 1;
  v_vards VARCHAR2(50);
  v_uzvards VARCHAR2(50);
  v_dzimis DATE;
  v_valsts VARCHAR2(50);

  v_nosaukums VARCHAR2(100);
  v_gads NUMBER;

  v_gramatu_skaits NUMBER;

  TYPE v_gramatu_kolekcija_tips IS VARRAY(151) OF GRAMATA_TYPE;
  v_gramatu_kolekcija v_gramatu_kolekcija_tips;
BEGIN
  FOR i IN 1..1000 LOOP
    v_gramatu_kolekcija := v_gramatu_kolekcija_tips();

    v_vards := DBMS_RANDOM.STRING('A', 10);
    v_uzvards := DBMS_RANDOM.STRING('A', 10);
    v_dzimis := TO_DATE('01-JAN-1880', 'DD-MON-YYYY') + DBMS_RANDOM.VALUE(0, 365*130);

    v_valsts := CASE ROUND(DBMS_RANDOM.VALUE(1, 10))
                  WHEN 1 THEN 'Latvija'
                  WHEN 2 THEN 'Kan?da' 
                  WHEN 3 THEN 'V?cija' 
                  WHEN 4 THEN 'Francija'
                  WHEN 5 THEN 'It?lija'
                  WHEN 6 THEN 'Sp?nija'
                  WHEN 7 THEN '??na'
                  WHEN 8 THEN 'Austr?lija'
                  WHEN 9 THEN 'Jap?na'
                  ELSE 'Indija'
               END;
INSERT INTO Autors (autora_id, vards, uzvards, dzimis, valsts)
    VALUES (
      i,
      v_vards,
      v_uzvards,
      v_dzimis,
      v_valsts
    );
    
    v_gramatu_skaits := ROUND(DBMS_RANDOM.VALUE(50, 151));
    
    FOR j IN 1..v_gramatu_skaits LOOP
      v_nosaukums := DBMS_RANDOM.STRING('A', 20);
      v_gads := ROUND(DBMS_RANDOM.VALUE(1900, 2023));
      INSERT INTO Gramata (gramata_id, nosaukums, izdevuma_gads, autora_id)
      VALUES (
        v_gramata_counter,
        v_nosaukums,
        v_gads,
        i
      );

      v_gramatu_kolekcija.EXTEND;
      v_gramatu_kolekcija(j) := GRAMATA_TYPE(v_gramata_counter, v_nosaukums, v_gads);
v_gramata_counter := v_gramata_counter + 1;
    END LOOP;

    INSERT INTO AutorsGramatas VALUES (
      AutorsGramatas_Type(
        Autors_Type(i, v_vards, v_uzvards, v_dzimis, v_valsts),
        GramatuKolekcija_Type(v_gramatu_kolekcija(1))
      )
    );
   
    FOR k in 2..v_gramatu_kolekcija.COUNT LOOP
      INSERT INTO TABLE (SELECT a.gramatas FROM AutorsGramatas a WHERE a.autors.autora_id = i)
        VALUES (v_gramatu_kolekcija(k));
    END LOOP;
  END LOOP;
  COMMIT;
END;
/
/*
Realizejam vaicajumus gan relaciju datu bazes variantam, gan relaciju – objektu datu bazes variantam.
Atrast videjo, minimalo un maksimalo gramatu skaitu, ko ir rakstijuši autori no katras valsts.
*/
ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;
SELECT Autors.valsts,
       AVG(BookCount) AS AvgBooksperAuthor,
       MIN(BookCount) AS MinBooksperAuthor,
       MAX(BookCount) AS MaxBooksperAuthor
FROM Autors 
JOIN (
       SELECT autora_id, COUNT(*) AS BookCount
       FROM Gramata
       GROUP BY autora_id
     ) BooksPerAuthor ON Autors.autora_id = BooksPerAuthora_id
GROUP BY Autors.valsts
ORDER BY Autors.valsts;

SET TIMING OFF;

ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;
SELECT a.autors.valsts,
       AVG((SELECT COUNT(*) FROM TABLE(a.gramatas))) AS AvgBooksPerAuthor,
       MIN((SELECT COUNT(*) FROM TABLE(a.gramatas))) AS MinBooksPerAuthor,
       MAX((SELECT COUNT(*) FROM TABLE(a.gramatas))) AS MaxBooksPerAuthor
FROM AutorsGramatas a
GROUP BY a.autors.valsts
ORDER BY a.Autors.valsts;

SET TIMING OFF;
/*
Izvadit autorus ar visvairak gramatam un to kopejo gramatu skaitu.
*/
ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;

SELECT Autors.autora_id, Autors.vards, Autors.uzvards, Autors.valsts, SUM(BookCount) AS TotalBookCount
FROM Autors
JOIN (
    SELECT autora_id, COUNT(*) AS BookCount
    FROM Gramata
    GROUP BY autora_id
) BooksPerAuthor ON Autors.autora_id = BooksPerAuthor.autora_id
GROUP BY Autors.autora_id, Autors.vards, Autors.uzvards, Autors.valsts
ORDER BY TotalBookCount DESC
FETCH FIRST 5 ROWS ONLY;

SET TIMING OFF;

ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;
SELECT a.autors.autora_id, a.autors.vards, a.autors.uzvards, a.autors.valsts, SUM((SELECT COUNT(*) FROM TABLE(a.gramatas))) AS TotalBookCount
FROM AutorsGramatas a
GROUP BY a.autors.autora_id, a.autors.vards, a.autors.uzvards, a.autors.valsts
ORDER BY TotalBookCount DESC
FETCH FIRST 5 ROWS ONLY;

SET TIMING OFF;
/*
Atrast piecus autorus ar augstako videjo gramatu skaitu katra desmitgada.
*/
ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;

SELECT Autors.autora_id,
       Autors.vards,
       Autors.uzvards,
       AVG(BookCount) AS AvgBooksPerDecade
FROM Autors
JOIN (
    SELECT autora_id,
           SUBSTR(izdevuma_gads, 1, 3) || '0s' AS publication_decade,
           COUNT(*) AS BookCount
    FROM Gramata
    GROUP BY autora_id, SUBSTR(izdevuma_gads, 1, 3)
    ) BooksPerDecade ON Autors.autora_id = BooksPerDecade.autora_id
GROUP BY Autors.autora_id, Autors.vards, Autors.uzvards
ORDER BY AvgBooksPerDecade DESC
FETCH FIRST 5 ROWS ONLY;

SET TIMING OFF;

ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;
SELECT ag.Autors.autora_id,
       ag.Autors.vards,
       ag.Autors.uzvards,
       AVG(BookCount) AS AvgBooksPerDecade
FROM AutorsGramatas ag
JOIN
(SELECT a.autors.autora_id as autora_id,
       SUBSTR(g.izdevuma_gads, 1, 3) || '0s' AS publication_decade,
       COUNT(*) AS BookCount
FROM AutorsGramatas a,
     TABLE(a.gramatas) g
GROUP BY a.autors.autora_id, SUBSTR(g.izdevuma_gads, 1, 3) || '0s') b
ON ag.Autors.autora_id = b.autora_id
GROUP BY ag.Autors.autora_id, ag.Autors.vards, ag.Autors.uzvards
ORDER BY AvgBooksPerDecade DESC
FETCH FIRST 5 ROWS ONLY;

SET TIMING OFF;
/*
Izmantojot abas objektu tabulas, veidojam objektu skatu, kura objektiem definet divas MEMBER tipa objektu metodes.
*/
CREATE OR REPLACE TYPE AutorsGramatas_Type AS OBJECT (
 autors Autors_Type,
 gramatas GramatuKolekcija_Type,
 
MEMBER FUNCTION get_total_books RETURN NUMBER,
MEMBER FUNCTION get_avg_books_per_decade RETURN NYMBER
);

CREATE OR REPLACE TYPE BODY AutorsGramatas_Type AS
  MEMBER FUNCTION get_total_books RETURN NUMBER IS
  v_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_result FROM TABLE(gramatas);
    RETURN v_result;
  END get_total_books;
  MEMBER FUNCTION get_avg_books_per_decade RETURN NUMBER IS
  v_result NUMBER;
  BEGIN
    SELECT AVG(BookCount) INTO v_result
    FROM
      (SELECT autors.autora_id as autora_id,
        SUBSTR(g.izdevuma_gads, 1, 3) AS publication_decade,
        COUNT(*) AS BookCount
       FROM TABLE(gramatas) g
       GROUP BY autors.autora_id, SUBSTR(g.izdevuma_gads, 1, 3));
    RETURN v_results;
  END get_avg_books_per_decade;
END;

CREATE OR REPLACE VIEW AutorsGramatas_View AS
SELECT ag.*,
       ag.get_total_books() AS total_books,
       ag.get_avg_books_per_decade() AS avg_books_per_decade
FROM AutorsGramatas ag;
/*
Vaicajumi objektu skatiem.
*/
ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;
SELECT
  agv.autors.valsts,
  AVG(total_books),
  MIN(total_books),
  MAX(total_books)
FROM AutorsGramatas_View agv
GROUP BY agv.autors.valsts
ORDER BY agv.autors.valsts;
SET TIMING OFF;
/*
2.vaicajums
*/
ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;
SELECT agv.autors.autora_id, 
       agv.autors.vards, 
       agv.autors.uzvards, 
       agv.autors.valsts, 
       SUM(total_books) AS TotalBookCount
FROM AutorsGramatas_View agv
GROUP BY agv.autors.autora_id, agv.autors.vards, agv.autors.uzvards, agv.autors.valsts
ORDER BY TotalBookCount DESC
FETCH FIRST 5 ROWS ONLY
SET TIMING OFF;
/*
3.vaicajums
*/
ALTER SYSTEM FLUSH SHARED_POOL;
SET TIMING ON;
SELECT agv.Autors.autora_id,
       agv.Autors.vards,
       agv.Autors.uzvards,
       agv.avg_books_per_decade
FROM AutorsGramatas_View agv
ORDER BY agv.avg_books_per_decade DESC
FETCH FIRST 5 ROWS ONLY;
SET TIMING OFF;
