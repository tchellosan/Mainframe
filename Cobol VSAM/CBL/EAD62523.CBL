      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62523.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62523                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : REWRITE RECORD VSAM FILE                     *
      *                                                                *
      *================================================================*
       ENVIRONMENT                 DIVISION.
      *================================================================*
       INPUT-OUTPUT                SECTION.

       FILE-CONTROL.

           SELECT VS001            ASSIGN TO VS001
               ORGANIZATION        IS INDEXED
               ACCESS MODE         IS DYNAMIC
               RECORD KEY          IS FD-ID-EMPLOYEE
               FILE STATUS         IS WS-FS-VS001.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

       FD  VS001.

       01  REG-VS001.
           05  FD-VS001-KEY.
               10  FD-ID-EMPLOYEE  PIC X(3).
           05  FD-NAME             PIC X(20).
           05  FD-DEPT             PIC X(5).
           05  FD-SALARY           PIC 9(3)V9(2).

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62523'.

       77  WS-FS-VS001             PIC X(2)            VALUE SPACES.

       77  WS-PARAGRAPH            PIC X(30)           VALUE SPACES.
       77  WS-RETURN-CODE          PIC 9(2)            VALUE ZEROS.
       77  WS-CODE                 PIC 9(2)            VALUE ZEROS.

       77  WS-NOT-FOUND            PIC X(2)            VALUE '23'.

       01  WS-ERROR-MESSAGE.
           05  FILLER              PIC X(30)           VALUE
           'VS001 NOT FOUND'.
           05  FILLER              PIC X(30)           VALUE
           'ERROR WHEN OPENING THE FILE'.
           05  FILLER              PIC X(30)           VALUE
           'EMPLOYEE NOT FOUND'.
           05  FILLER              PIC X(30)           VALUE
           'ERROR WRITING IN FILE'.
           05  FILLER              PIC X(30)           VALUE
           'ERROR WHEN CLOSING THE FILE'.
           05  FILLER              PIC X(30)           VALUE
           'KEY FIELD INVALID'.
           05  FILLER              PIC X(30)           VALUE
           'REWRITE FAILED'.
       01  FILLER                      REDEFINES WS-ERROR-MESSAGE.
           05  WS-MESSAGE              PIC X(30) OCCURS 7 TIMES.

       01  WS-REG-VS001.
           05  WS-VS001-KEY.
               10  WS-ID-EMPLOYEE  PIC X(3).
           05  WS-NAME             PIC X(20).
           05  WS-ID-DEPT          PIC X(5).
           05  WS-SALARY           PIC 9(3)V9(2).

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

           PERFORM 0100-00-INITIAL.

           PERFORM 0200-00-CENTRAL-PROCESSING.

           PERFORM 0300-00-FINAL.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

           PERFORM 0401-00-READ-SYSIN.

           PERFORM 0402-00-VALIDATE-KEY.

           PERFORM 0501-00-OPEN-VS001.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

           PERFORM 0502-00-READ-VS001.

           DISPLAY 'OLD RECORD  '.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY 'FD-ID-EMPLOYEE: ' FD-ID-EMPLOYEE.
           DISPLAY 'FD-NAME.......: ' FD-NAME.
           DISPLAY 'FD-DEPT....: ' FD-DEPT.
           DISPLAY 'FD-SALARY.....: ' FD-SALARY.

           PERFORM 0503-00-REWRITE-VS001.

           DISPLAY SPACES.
           DISPLAY 'NEW RECORD  '.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY 'FD-ID-EMPLOYEE: ' FD-ID-EMPLOYEE.
           DISPLAY 'FD-NAME.......: ' FD-NAME.
           DISPLAY 'FD-DEPT....: ' FD-DEPT.
           DISPLAY 'FD-SALARY.....: ' FD-SALARY.

      *----------------------------------------------------------------*
       0300-00-FINAL               SECTION.
      *----------------------------------------------------------------*

           PERFORM 0504-00-CLOSE-VS001.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

           MOVE ZEROS              TO RETURN-CODE.

           STOP RUN.

      *----------------------------------------------------------------*
       0400-00-FILE-SYSIN          SECTION.
      *----------------------------------------------------------------*

       0401-00-READ-SYSIN.

           ACCEPT WS-REG-VS001     FROM SYSIN.

           MOVE WS-ID-EMPLOYEE     TO FD-ID-EMPLOYEE.

       0401-00-EXIT.
           EXIT.

       0402-00-VALIDATE-KEY.

           MOVE '0402-00-VALIDATE-KEY'
                                   TO WS-PARAGRAPH.

           IF  WS-ID-EMPLOYEE      NOT NUMERIC OR
               WS-ID-EMPLOYEE      EQUAL ZEROS
               MOVE 6              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
           END-IF.

       0402-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0500-00-FILE-VS001          SECTION.
      *----------------------------------------------------------------*

       0501-00-OPEN-VS001.

           OPEN I-O VS001.

           EVALUATE WS-FS-VS001
             WHEN '00'
               CONTINUE
             WHEN '35'
               MOVE 1              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
             WHEN OTHER
               MOVE 2              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
           END-EVALUATE.

       0501-00-EXIT.
           EXIT.

       0502-00-READ-VS001.

           MOVE '0502-00-READ-VS001'
                                   TO WS-PARAGRAPH.

           READ VS001.

           EVALUATE WS-FS-VS001
             WHEN '00'
               CONTINUE
             WHEN WS-NOT-FOUND
               MOVE 3              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
             WHEN OTHER
               MOVE 4              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
           END-EVALUATE.

       0502-00-EXIT.
           EXIT.

       0503-00-REWRITE-VS001.

           MOVE '0503-00-REWRITE-VS001'
                                   TO WS-PARAGRAPH.

           REWRITE REG-VS001       FROM WS-REG-VS001.

           EVALUATE WS-FS-VS001
             WHEN '00'
               CONTINUE
             WHEN WS-NOT-FOUND
               MOVE 3              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
             WHEN OTHER
               MOVE 7              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
           END-EVALUATE.

       0503-00-EXIT.
           EXIT.

       0504-00-CLOSE-VS001.

           MOVE '0504-00-CLOSE-VS001'
                                   TO WS-PARAGRAPH.

           CLOSE VS001.

           EVALUATE WS-FS-VS001
             WHEN '00'
               CONTINUE
             WHEN OTHER
               MOVE 5              TO WS-CODE
               MOVE 12             TO WS-RETURN-CODE
               PERFORM 0901-00-ERROR
           END-EVALUATE.

       0504-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-ERROR               SECTION.
      *----------------------------------------------------------------*

       0901-00-ERROR.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM FAILED                      *'.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY '*                                              *'.
           DISPLAY '* PARAGRAPH..: ' WS-PARAGRAPH '  *'.
           DISPLAY '* MESSAGE....: ' WS-MESSAGE(WS-CODE) '  *'.
           DISPLAY '*                                              *'.
           DISPLAY '*----------------------------------------------*'.

           MOVE WS-RETURN-CODE     TO RETURN-CODE.

           STOP RUN.

       0901-00-EXIT.
           EXIT.