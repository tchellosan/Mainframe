      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62513.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62513                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : SHOW SALES BY SELLER, STATE AND MONTH        *
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

           SELECT SALES3L          ASSIGN TO DA-S-SALES3L
               FILE STATUS         IS WS-FS-SALES3L.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

       FD  SALES3L
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-SALES3L.
           03  FD-SELLER           PIC 9(2).
           03  FD-STATE            PIC X(2).
           03  FD-MONTH            PIC 9(2).
           03  FD-INVOICE          PIC 9(6).
           03  FD-VALUE            PIC 9(6)V9(2).

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62513'.

       77  WS-FS-SALES3L           PIC X(2)            VALUE ZEROS.

       77  WS-READ-SALES3L         PIC 9(3)            VALUE ZEROS.

       77  WS-FMT-AMOUNT           PIC ZZ9             VALUE ZEROS.

       77  WS-SE                   PIC 9(2) COMP-3     VALUE ZEROS.
       77  WS-ST                   PIC 9(2) COMP-3     VALUE ZEROS.
       77  WS-MO                   PIC 9(2) COMP-3     VALUE ZEROS.
       77  WS-POS                  PIC 9(2) COMP-3     VALUE ZEROS.

       01  WS-STATES.
           03 FILLER               PIC X(4)            VALUE '01SP'.
           03 FILLER               PIC X(4)            VALUE '02RJ'.
           03 FILLER               PIC X(4)            VALUE '03MG'.
       01  WS-STATES-R             REDEFINES WS-STATES.
           03 FILLER               OCCURS 3 TIMES.
              05 WS-STATE-CODE     PIC 9(2).
              05 WS-STATE-ID       PIC X(2).

       01  WS-TOTAL.
           03  WS-SELLER           OCCURS 2 TIMES.
               05  WS-STATE        OCCURS 3 TIMES.
                   07  WS-MONTH    OCCURS 4 TIMES.
                       09  WS-TOT-VALUE
                                   PIC 9(8)V9(2)       VALUE ZEROS.

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
             UNTIL WS-FS-SALES3L   EQUAL '10'.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

      *    INITIALIZE WS-TOTAL.

           PERFORM 0102-00-OPEN-SALES3L.

       0101-00-EXIT.
           EXIT.

       0102-00-OPEN-SALES3L.

           OPEN INPUT SALES3L.

           EVALUATE WS-FS-SALES3L
             WHEN '00'
               PERFORM 0301-00-READ-SALES3L
             WHEN '35'
               DISPLAY ' CUSTOMER FILE NOT FOUND'
               MOVE 12             TO RETURN-CODE
               STOP RUN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0102-00-OPEN-SALES3L'
                                    ' FILE STATUS: ' WS-FS-SALES3L
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0102-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           PERFORM 0202-00-GET-STATE-CODE.

           IF  WS-POS              NOT GREATER 3
               MOVE WS-STATE-CODE(WS-POS)
                                   TO WS-POS
           ADD FD-VALUE            TO
                              WS-TOT-VALUE(FD-SELLER, WS-POS, FD-MONTH)
           ELSE
               DISPLAY 'STATE IDENTIFIER INVALID'
           END-IF.

           PERFORM 0301-00-READ-SALES3L.

       0201-00-EXIT.
           EXIT.

       0202-00-GET-STATE-CODE.

           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS        GREATER 3
               IF  WS-STATE-ID(WS-POS)
                                   EQUAL FD-STATE
                   NEXT SENTENCE
               END-IF
           END-PERFORM.

       0202-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-READ                SECTION.
      *----------------------------------------------------------------*

       0301-00-READ-SALES3L.

           READ SALES3L.

           EVALUATE WS-FS-SALES3L
             WHEN '00'
               ADD 1               TO WS-READ-SALES3L
             WHEN '10'
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0301-00-READ-SALES3L'
                                    ' FILE STATUS: ' WS-FS-SALES3L
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0301-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           PERFORM VARYING WS-SE FROM 1 BY 1
             UNTIL WS-SE           GREATER 2
               PERFORM VARYING WS-ST FROM 1 BY 1
                 UNTIL WS-ST       GREATER 3
                   PERFORM VARYING WS-MO FROM 1 BY 1
                     UNTIL WS-MO   GREATER 4
                       IF  WS-TOT-VALUE(WS-SE, WS-ST, WS-MO)
                                   GREATER ZEROS
                           MOVE WS-TOT-VALUE(WS-SE, WS-ST, WS-MO)
                                   TO WS-FMT-VALUE
                           DISPLAY ' TOTAL SALES FROM SELLER ' WS-SE
                               ' IN STATE ' WS-STATE-ID(WS-ST)
                               ' IN MONTH OF ' '(' WS-MO ') => $ '
                                                          WS-FMT-VALUE
                       END-IF
                  END-PERFORM
               END-PERFORM
           END-PERFORM.

           PERFORM 0902-00-CLOSE-FILES.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY '*                                              *'.
           MOVE WS-READ-SALES3L    TO WS-FMT-AMOUNT
           DISPLAY '*  READ SALES3L: ' WS-FMT-AMOUNT
                                     '                           *'.
           DISPLAY '*                                              *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.

       0902-00-CLOSE-FILES.

           CLOSE SALES3L.

       0902-00-EXIT.
           EXIT.