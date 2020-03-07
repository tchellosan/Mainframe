      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62517.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62517                                     *
      *   LANGUAGE      : COBOL/DB2                                    *
      *   TARGET        : READ AND DISPLAY ALL EMPLOYEES               *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62517'.

       77  WS-FMT-SALARY           PIC ZZZ.ZZ9,99      VALUE ZEROS.

       77  WS-FMT-SQLCODE          PIC -9(3)           VALUE ZEROS.

       77  WS-NULL-EMAIL           PIC S9(4) COMP      VALUE ZEROS.

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
                 ORDER BY SALARY
           END-EXEC.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           PERFORM 0201-00-CENTRAL-PROCESSING
             UNTIL SQLCODE         EQUAL +100.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           PERFORM 0301-00-OPEN-CSR-EADD0002.

       0101-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           DISPLAY 'ID-EMPLOYEE: ' ID-EMPLOYEE OF EADD0002.
           DISPLAY 'NAME.......: ' NAME-TEXT   OF EADD0002.
           MOVE SALARY OF EADD0002 TO WS-FMT-SALARY.
           DISPLAY 'SALARY.....: ' WS-FMT-SALARY.
           DISPLAY 'ID-DEPT....: ' ID-DEPT     OF EADD0002.
           DISPLAY 'ADMISSION..: ' ADMISSION   OF EADD0002.
           DISPLAY 'AGE........: ' AGE         OF EADD0002.
           DISPLAY 'EMAIL......: ' EMAIL-TEXT  OF EADD0002.
           DISPLAY SPACES.

           PERFORM 0302-00-FETCH-CSR-EADD0002.

       0201-00-EXIT.
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
               PERFORM 0302-00-FETCH-CSR-EADD0002
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
             WHEN +100
               DISPLAY 'THERE ARE NO MORE LINES TO BE READ.'
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
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           PERFORM 0303-00-CLOSE-CSR-EADD0002.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.