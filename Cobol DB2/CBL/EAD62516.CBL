      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62516.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62516                                     *
      *   LANGUAGE      : COBOL/DB2                                    *
      *   TARGET        : READ AND DISPLAY EMPLOYEE                    *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62516'.

       77  WS-ID-EMPLOYEE          PIC X(4)            VALUE SPACES.

       77  WS-FMT-SALARY           PIC ZZZ.ZZ9,99      VALUE ZEROS.

       77  WS-FMT-SQLCODE          PIC -9(3)           VALUE ZEROS.

      *----------------------------------------------------------------*
      *  DB2 AREA                                                      *
      *----------------------------------------------------------------*

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
               INCLUDE EADD0002
           END-EXEC.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           IF  SQLCODE             EQUAL ZEROS
               PERFORM 0201-00-CENTRAL-PROCESSING
           END-IF.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           ACCEPT WS-ID-EMPLOYEE   FROM SYSIN.

           PERFORM 0301-00-SELECT-EMPLOYEE.

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

       0201-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-EADD0002            SECTION.
      *----------------------------------------------------------------*

       0301-00-SELECT-EMPLOYEE.

           MOVE WS-ID-EMPLOYEE     TO ID-EMPLOYEE OF EADD0002.

           EXEC SQL
               SELECT ID_EMPLOYEE
                    , NAME
                    , SALARY
                    , ID_DEPT
                    , ADMISSION
                    , AGE
                    , EMAIL
                 INTO :EADD0002.ID-EMPLOYEE
                    , :EADD0002.NAME
                    , :EADD0002.SALARY
                    , :EADD0002.ID-DEPT
                    , :EADD0002.ADMISSION
                    , :EADD0002.AGE
                    , :EADD0002.EMAIL
                 FROM EAD625.EMPLOYEE
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC.

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               DISPLAY 'EMPLOYEE NOT FOUND'
               STOP RUN
             WHEN OTHER
               MOVE SQLCODE        TO WS-FMT-SQLCODE
               DISPLAY 'ERROR WHEN SELECTING EMPLOYEE IN THE DATABASE.'
                       ' (SQLCODE: ' WS-FMT-SQLCODE ')'
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0301-00-EXIT.
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