      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62512.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62512                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : SHOW TOTAL SALES PER MONTH                   *
      *                                                                *
      *================================================================*
       ENVIRONMENT                 DIVISION.
      *================================================================*
       CONFIGURATION               SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      *----------------------------------------------------------------*
       INPUT-OUTPUT                SECTION.

       FILE-CONTROL.

           SELECT SALES            ASSIGN TO DA-S-SALES
               FILE STATUS         IS WS-FS-SALES.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

       FD  SALES
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-SALES.
           03  FD-INVOICE          PIC 9(6).
           03  FD-MONTH            PIC 9(2).
           03  FD-VALUE            PIC 9(6)V9(2).

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62512'.

       77  WS-FS-SALES             PIC X(2)            VALUE ZEROS.

       77  WS-READ-SALES           PIC 9(3)            VALUE ZEROS.

       77  WS-FMT-AMOUNT           PIC ZZ9             VALUE ZEROS.

       77  WS-INVALID-MONTH        PIC 9(2) COMP-3     VALUE 13.

       77  WS-IND-MONTH            PIC 9(2) COMP-3     VALUE ZEROS.

       01  WS-TOTAL-MONTH.
           03  WS-MONTH            PIC 9(8)V9(2) OCCURS 13 TIMES
                                                       VALUE ZEROS.

       77  WS-FMT-VALUE            PIC ZZ.ZZZ.ZZ9,99   VALUE ZEROS.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           PERFORM 0201-00-CENTRAL-PROCESSING
             UNTIL WS-FS-SALES     EQUAL '10'.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           PERFORM 0102-00-OPEN-SALES.

       0101-00-EXIT.
           EXIT.

       0102-00-OPEN-SALES.

           OPEN INPUT SALES.

           EVALUATE WS-FS-SALES
             WHEN '00'
               PERFORM 0301-00-READ-SALES
             WHEN '35'
               DISPLAY ' CUSTOMER FILE NOT FOUND'
               MOVE 12             TO RETURN-CODE
               STOP RUN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0102-00-OPEN-SALES'
                                    ' FILE STATUS: ' WS-FS-SALES
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0102-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           IF  FD-MONTH            NOT LESS     1 AND
               FD-MONTH            NOT GREATER 12
               ADD FD-VALUE    TO WS-MONTH(FD-MONTH)
           ELSE
               ADD FD-VALUE    TO WS-MONTH(WS-INVALID-MONTH)
           END-IF.

           PERFORM 0301-00-READ-SALES.

       0201-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-READ                SECTION.
      *----------------------------------------------------------------*

       0301-00-READ-SALES.

           READ SALES.

           EVALUATE WS-FS-SALES
             WHEN '00'
               ADD 1               TO WS-READ-SALES
             WHEN '10'
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0301-00-READ-SALES'
                                    ' FILE STATUS: ' WS-FS-SALES
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0301-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           PERFORM VARYING WS-IND-MONTH FROM 1 BY 1
             UNTIL WS-IND-MONTH GREATER 12
               MOVE WS-MONTH(WS-IND-MONTH)
                                   TO WS-FMT-VALUE
               DISPLAY 'TOTAL SALES FOR THE MONTH '
               '(' WS-IND-MONTH ') => $ ' WS-FMT-VALUE
           END-PERFORM.

           IF  WS-MONTH(WS-INVALID-MONTH)
                                   GREATER ZEROS
               MOVE WS-MONTH(WS-INVALID-MONTH)
                                   TO WS-FMT-VALUE
               DISPLAY 'TOTAL SALES WITH INVALID MONTH => $ '
                                                         WS-FMT-VALUE
           END-IF.

           PERFORM 0902-00-CLOSE-FILES.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY '*                                              *'.
           MOVE WS-READ-SALES      TO WS-FMT-AMOUNT
           DISPLAY '*  READ SALES: ' WS-FMT-AMOUNT
                                     '                             *'.
           DISPLAY '*                                              *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.

       0902-00-CLOSE-FILES.

           CLOSE SALES.

       0902-00-EXIT.
           EXIT.