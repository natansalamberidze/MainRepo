/*
"Read Committed" isolation level tables and data.
*/
CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Quantity INT
);

INSERT INTO Inventory (ProductID, ProductName, Quantity) VALUES(1, 'T-krekls', 100);
INSERT INTO Inventory (ProductID, ProductName, Quantity) VALUES(2, 'Džinsi', 50);
/*
"Serializable" insulation level tables and data.
*/
CREATE TABLE Noliktava (
    ProduktaID INT PRIMARY KEY,
    ProduktaNosaukums VARCHAR(100),
    Daudzums INT
);
INSERT INTO Noliktava VALUES (1, 'Dators', 30);
INSERT INTO Noliktava VALUES (2, 'Printeri', 15);
/*
Need to create multiple users and execute a transaction from each of them, at the same time.
Two users are created, natans and natans2.
Both users are given all necessary access.
*/
CREATE USER natans IDENTIFIED BY natans;
GRANT CREATE SESSION TO new_user;
GRANT CREATE TABLE TO c##natans;
GRANT ALTER TABLE TO c##natans;
ALTER SESSION SET CONTAINER = CDB$ROOT;
CREATE USER c##natans IDENTIFIED BY natans;
GRANT CONNECT, RESOURCE TO c##natans;
ALTER USER c##natans QUOTA 100M ON USERS;
GRANT EXECUTE ON DBMS_LOCK TO c##natans;
/
CREATE USER c##natans2 IDENTIFIED BY natans2;
GRANT CONNECT, RESOURCE TO c##natans2;
GRANT CREATE TABLE TO c##natans2;
GRANT ALTER TABLE TO c##natans2;
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER USER c##natans2 QUOTA 100M ON USERS;
GRANT EXECUTE ON DBMS_LOCK TO c##natans2;
/*
Transaction 1. (Read Committed)
*/
BEGIN
    UPDATE Inventory SET Quantity = Quantity + 50 WHERE ProductID = 1;
    DBMS_LOCK.SLEEP(5);
    COMMIT;
END;
/*
Transaction 2.
*/
BEGIN
    UPDATE "C##NATANS"."INVENTORY" SET Quantity = Quantity * 2 WHERE ProductID = 1;
    COMMIT;
END;
/*
Let's check
*/
select * from "C##NATANS"."INVENTORY";
/*
Serializable.
*/
CREATE TABLE Noliktava (
    ProduktaID INT PRIMARY KEY,
    ProduktaNosaukums VARCHAR(100),
    Daudzums INT
);
INSERT INTO Noliktava VALUES (1, 'Dators', 30);
INSERT INTO Noliktava VALUES (2, 'Printeri', 15);
GRANT SELECT, INSERT, UPDATE, DELETE ON Noliktava TO c##natans2;
COMMIT;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN
    UPDATE Noliktava SET Daudzums = Daudzums - 5 WHERE ProduktaID = 1;
    DBMS_LOCK.SLEEP(10);
    COMMIT;
END;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN
    UPDATE "C##NATANS"."NOLIKTAVA" SET Daudzums = Daudzums * 10 WHERE ProduktaID = 1;
    DBMS_LOCK.SLEEP(5);
    COMMIT;
END;
/*
Let's check
*/
select * from "C##NATANS"."NOLIKTAVA";
/*
Using active database triggers.
*/
CREATE TABLE InventoryLog (
    LogID INT PRIMARY KEY,
    ProductID INT,
    OldQuantity INT,
    NewQuantity INT,
    ChangeTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE InventoryLogSeq START WITH 1;

CREATE OR REPLACE TRIGGER InventoryChangeTrigger
AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    INSERT INTO InventoryLog (LogID, ProductID, OldQuantity, NewQuantity)
    VALUES (InventoryLogSeq.NEXTVAL, :OLD.ProductID, :OLD.Quantity, :NEW.Quantity);
END;
/*
Let's check
*/
select * from InventoryLog;
