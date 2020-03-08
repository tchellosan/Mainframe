----------------------------------------------------------------------
--   DROP TABLE DEPT;
--   DROP TABLE EMPLOYEE;

----------------------------------------------------------------------
CREATE TABLE DEPT (
	ID_DEPT CHAR(3) PRIMARY KEY NOT NULL,
	NAME VARCHAR(30) NOT NULL
	);

----------------------------------------------------------------------
CREATE TABLE EMPLOYEE (
	ID_EMPLOYEE  CHAR(4) PRIMARY KEY NOT NULL,
	NAME         VARCHAR(30)  NOT NULL,
	SALARY       DECIMAL(8,2) NOT NULL,
	ID_DEPT      CHAR(3)      NOT NULL,
	ADMISSION    DATE         NOT NULL,
	AGE          SMALLINT     NOT NULL,
	EMAIL        VARCHAR(30)
	);

----------------------------------------------------------------------
CREATE UNIQUE INDEX IDX_DEPT    ON DEPT(ID_DEPT);
CREATE UNIQUE INDEX IDX_EMPLOYEE ON EMPLOYEE(ID_EMPLOYEE);

----------------------------------------------------------------------
ALTER TABLE EMPLOYEE
ADD FOREIGN KEY(ID_DEPT) REFERENCES DEPT(ID_DEPT)
ON DELETE RESTRICT;