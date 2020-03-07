      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62518.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62518                                     *
      *   LANGUAGE      : COBOL/DB2                                    *
      *   TARGET        : INSERT, UPDATE AND DELETE EMPLOYEES          *
      *                                                                *
      *================================================================*
       ENVIRONMENT                 DIVISION.
      *================================================================*
       CONFIGURATION               SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62518'.

       01  WS-SYSIN.
           03  WS-FUNCTION         PIC X(1)            VALUE SPACES.
               88  WS-INSERT                           VALUE 'I'.
               88  WS-UPDATE                           VALUE 'U'.
               88  WS-DELETE                           VALUE 'D'.
               88  WS-LIST                             VALUE 'L'.
           03  WS-ID-EMPLOYEE      PIC X(4)            VALUE SPACES.
           03  WS-SALARY           PIC 9(6)V9(2)       VALUE ZEROS.
           03  WS-ID-DEPT          PIC X(3)            VALUE SPACES.
           03  WS-ADMISSION        PIC X(10)           VALUE SPACES.
           03  WS-AGE              PIC 9(2)            VALUE ZEROS.
           03  WS-NAME             PIC X(30)           VALUE SPACES.
           03  WS-EMAIL            PIC X(30)           VALUE SPACES.

       77  WS-FMT-SALARY           PIC ZZZ.ZZ9,99      VALUE ZEROS.
       77  WS-FMT-SQLCODE          PIC -9(3)           VALUE ZEROS.

       77  WS-NULL-EMAIL           PIC S9(4) COMP      VALUE ZEROS.

       77  WS-AMOUNT-LETTERS       PIC S9(2) COMP-3    VALUE ZEROS.
       77  WS-TEXT                 PIC X(30)           VALUE SPACES.

      *----------------------------------------------------------------*
      *  DB2 AREA                                                      *
      *----------------------------------------------------------------*

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
               INCLUDE EADD0002
           END-EXEC.

           EXEC SQL
               DECLARE CSR-EADD0002 CURSOR FOR
                SELECT ID_EMPLOYEE
                     , NAME
                     , SALARY
                     , ID_DEPT
                     , ADMISSION
                     , AGE
                     , EMAIL
                  FROM EAD625.EMPLOYEE
                 ORDER BY CAST(SUBSTR(ID_EMPLOYEE, 3, 2) AS DECIMAL)
           END-EXEC.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           PERFORM 0201-00-CENTRAL-PROCESSING.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           ACCEPT WS-FUNCTION      FROM SYSIN.
           ACCEPT WS-ID-EMPLOYEE   FROM SYSIN.
           ACCEPT WS-NAME          FROM SYSIN.
           ACCEPT WS-SALARY        FROM SYSIN.
           ACCEPT WS-ID-DEPT       FROM SYSIN.
           ACCEPT WS-ADMISSION     FROM SYSIN.
           ACCEPT WS-AGE           FROM SYSIN.
           ACCEPT WS-EMAIL         FROM SYSIN.

           IF  WS-ID-EMPLOYEE      EQUAL SPACES
               DISPLAY 'EMPLOYEE ID MUST BE INFORMED'
               STOP RUN
           END-IF.

       0101-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           INITIALIZE EADD0002 REPLACING NUMERIC      BY ZEROS
                                         ALPHANUMERIC BY SPACES.

           EVALUATE TRUE
             WHEN WS-INSERT
               PERFORM 0202-00-INSERT-EMPLOYEE
               PERFORM 0206-00-DISPLAY-EMPLOYEES

             WHEN WS-UPDATE
               PERFORM 0203-00-UPDATE-EMPLOYEE
               PERFORM 0206-00-DISPLAY-EMPLOYEES

             WHEN WS-DELETE
               PERFORM 0204-00-DELETE-EMPLOYEE
               PERFORM 0206-00-DISPLAY-EMPLOYEES

             WHEN WS-LIST
               PERFORM 0206-00-DISPLAY-EMPLOYEES

             WHEN OTHER
               DISPLAY 'INVALID FUNCTION (' WS-FUNCTION ')'
               STOP RUN

           END-EVALUATE.

       0201-00-EXIT.
           EXIT.

       0202-00-INSERT-EMPLOYEE.

           MOVE WS-ID-EMPLOYEE     TO ID-EMPLOYEE OF EADD0002.

           MOVE WS-NAME            TO WS-TEXT.
           PERFORM 0205-00-AMOUNT-LETTERS-TEXT.
           MOVE WS-AMOUNT-LETTERS  TO NAME-LEN.
           MOVE WS-TEXT            TO NAME-TEXT   OF EADD0002.

           MOVE WS-SALARY          TO SALARY      OF EADD0002.
           MOVE WS-ID-DEPT         TO ID-DEPT     OF EADD0002.
           MOVE WS-ADMISSION       TO ADMISSION   OF EADD0002.
           MOVE WS-AGE             TO AGE         OF EADD0002.

           MOVE WS-EMAIL           TO WS-TEXT.
           PERFORM 0205-00-AMOUNT-LETTERS-TEXT.
           MOVE WS-AMOUNT-LETTERS  TO EMAIL-LEN.

           IF  EMAIL-LEN           GREATER ZEROS
               MOVE WS-TEXT        TO EMAIL-TEXT  OF EADD0002
               MOVE ZEROS          TO WS-NULL-EMAIL
           ELSE
               MOVE -1             TO WS-NULL-EMAIL
           END-IF.

           EXEC SQL
               INSERT INTO EAD625.EMPLOYEE
               VALUES (:EADD0002.ID-EMPLOYEE
                     , :EADD0002.NAME
                     , :EADD0002.SALARY
                     , :EADD0002.ID-DEPT
                     , :EADD0002.ADMISSION
                     , :EADD0002.AGE
                     , :EADD0002.EMAIL INDICATOR :WS-NULL-EMAIL)
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN -530
               DISPLAY 'THE EMPLOYEE DEPARTMENT DOES NOT EXIST.'
               DISPLAY SPACES
             WHEN -803
               DISPLAY 'EMPLOYEE HAS ALREADY BEEN INCLUDED.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0202-00-INSERT-EMPLOYEE.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0202-00-EXIT.
           EXIT.

       0203-00-UPDATE-EMPLOYEE.

           MOVE WS-ID-EMPLOYEE     TO ID-EMPLOYEE OF EADD0002.

           IF  WS-NAME             NOT EQUAL SPACES
               PERFORM 0401-00-UPDATE-NAME
               IF  SQLCODE         EQUAL +100
                   NEXT SENTENCE
               END-IF
           END-IF

           IF  WS-SALARY           IS NUMERIC
               PERFORM 0402-00-UPDATE-SALARY
               IF  SQLCODE         EQUAL +100
                   NEXT SENTENCE
               END-IF
           END-IF

           IF  WS-ID-DEPT          NOT EQUAL SPACES
               PERFORM 0403-00-UPDATE-DEPT
               IF  SQLCODE         EQUAL +100
                   NEXT SENTENCE
               END-IF
           END-IF

           IF  WS-ADMISSION        NOT EQUAL SPACES
               PERFORM 0404-00-UPDATE-ADMISSION
               IF  SQLCODE         EQUAL +100
                   NEXT SENTENCE
               END-IF
           END-IF

           IF  WS-AGE              IS NUMERIC
               PERFORM 0405-00-UPDATE-AGE
               IF  SQLCODE         EQUAL +100
                   NEXT SENTENCE
               END-IF
           END-IF

           IF  WS-EMAIL            NOT EQUAL SPACES
               PERFORM 0406-00-UPDATE-EMAIL
               IF  SQLCODE         EQUAL +100
                   NEXT SENTENCE
               END-IF
           END-IF
           .

       0203-00-EXIT.
           EXIT.

       0204-00-DELETE-EMPLOYEE.

           MOVE WS-ID-EMPLOYEE     TO ID-EMPLOYEE OF EADD0002.

           EXEC SQL
               DELETE FROM EAD625.EMPLOYEE
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               DISPLAY 'ERASED EMPLOYEE: ' ID-EMPLOYEE OF EADD0002
               DISPLAY SPACES
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0204-00-DELETE-EMPLOYEE.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0204-00-EXIT.
           EXIT.

       0205-00-AMOUNT-LETTERS-TEXT.

           PERFORM VARYING WS-AMOUNT-LETTERS FROM 30 BY -1
               UNTIL WS-TEXT(WS-AMOUNT-LETTERS:1)
                                   NOT EQUAL SPACES
               CONTINUE
           END-PERFORM.

       0205-00-EXIT.
           EXIT.

       0206-00-DISPLAY-EMPLOYEES.

           PERFORM 0301-00-OPEN-CSR-EADD0002.

           PERFORM 0302-00-FETCH-CSR-EADD0002
             UNTIL SQLCODE         EQUAL +100.

           PERFORM 0303-00-CLOSE-CSR-EADD0002.

       0206-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-EADD0002            SECTION.
      *----------------------------------------------------------------*

       0301-00-OPEN-CSR-EADD0002.

           EXEC SQL
               OPEN CSR-EADD0002
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0301-00-OPEN-CSR-EADD0002.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0301-00-EXIT.
           EXIT.

       0302-00-FETCH-CSR-EADD0002.

           INITIALIZE EADD0002 REPLACING NUMERIC      BY ZEROS
                                         ALPHANUMERIC BY SPACES.

           EXEC SQL
               FETCH CSR-EADD0002
                INTO :EADD0002.ID-EMPLOYEE
                   , :EADD0002.NAME
                   , :EADD0002.SALARY
                   , :EADD0002.ID-DEPT
                   , :EADD0002.ADMISSION
                   , :EADD0002.AGE
                   , :EADD0002.EMAIL INDICATOR :WS-NULL-EMAIL
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               IF  WS-NULL-EMAIL   EQUAL -1
                   MOVE SPACES     TO EMAIL-TEXT OF EADD0002
               END-IF

               MOVE SALARY OF EADD0002 TO WS-FMT-SALARY

               DISPLAY ID-EMPLOYEE OF EADD0002 ' | '
                       WS-FMT-SALARY           ' | '
                       ID-DEPT     OF EADD0002 ' | '
                       ADMISSION   OF EADD0002 ' | '
                       AGE         OF EADD0002 ' | '
                       NAME-TEXT   OF EADD0002 ' | '
                       EMAIL-TEXT  OF EADD0002
             WHEN +100
               DISPLAY SPACES
               DISPLAY 'THERE ARE NO MORE LINES TO BE READ.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0302-00-FETCH-CSR-EADD0002.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0302-00-EXIT.
           EXIT.

       0303-00-CLOSE-CSR-EADD0002.

           EXEC SQL
               CLOSE CSR-EADD0002
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0303-00-CLOSE-CSR-EADD0002.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0303-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0400-00-UPDATE-FIELDS       SECTION.
      *----------------------------------------------------------------*

       0401-00-UPDATE-NAME.

           MOVE WS-NAME            TO WS-TEXT.
           PERFORM 0205-00-AMOUNT-LETTERS-TEXT.
           MOVE WS-AMOUNT-LETTERS  TO NAME-LEN.
           MOVE WS-TEXT            TO NAME-TEXT OF EADD0002.

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET NAME = :EADD0002.NAME
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0401-00-UPDATE-NAME.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0401-00-EXIT.
           EXIT.

       0402-00-UPDATE-SALARY.

           MOVE WS-SALARY          TO SALARY      OF EADD0002.

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET SALARY = :EADD0002.SALARY
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0402-00-UPDATE-SALARY.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0402-00-EXIT.
           EXIT.

       0403-00-UPDATE-DEPT.

           MOVE WS-ID-DEPT         TO ID-DEPT     OF EADD0002.

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET ID_DEPT = :EADD0002.ID-DEPT
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND.'
               DISPLAY SPACES
             WHEN -530
               DISPLAY 'THE EMPLOYEE DEPARTMENT DOES NOT EXIST.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0403-00-UPDATE-DEPT.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0403-00-EXIT.
           EXIT.

       0404-00-UPDATE-ADMISSION.

           MOVE WS-ADMISSION       TO ADMISSION   OF EADD0002.

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET ADMISSION = :EADD0002.ADMISSION
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0404-00-UPDATE-ADMISSION.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0404-00-EXIT.
           EXIT.

       0405-00-UPDATE-AGE.

           MOVE WS-AGE             TO AGE         OF EADD0002.

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET AGE = :EADD0002.AGE
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0405-00-UPDATE-AGE.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0405-00-EXIT.
           EXIT.

       0406-00-UPDATE-EMAIL.

           MOVE WS-EMAIL           TO WS-TEXT.
           PERFORM 0205-00-AMOUNT-LETTERS-TEXT.
           MOVE WS-AMOUNT-LETTERS  TO EMAIL-LEN.

           IF  EMAIL-LEN           GREATER ZEROS
               MOVE WS-TEXT        TO EMAIL-TEXT  OF EADD0002
               MOVE ZEROS          TO WS-NULL-EMAIL
           ELSE
               MOVE -1             TO WS-NULL-EMAIL
           END-IF.

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET EMAIL = :EADD0002.EMAIL INDICATOR :WS-NULL-EMAIL
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND.'
               DISPLAY SPACES
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY ' ERROR FOUND IN 0406-00-UPDATE-EMAIL.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0406-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.