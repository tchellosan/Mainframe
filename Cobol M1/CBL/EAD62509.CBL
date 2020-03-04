      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62509.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62509                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : READ AND DISPLAY CLIENTS FILE                *
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

           SELECT CLIENTS          ASSIGN TO DA-S-CLIENTS
               FILE STATUS         IS WS-FS-CLIENTS.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

       FD  CLIENTS
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-CLIENTS.
           03  FD-BANK-BRANCH      PIC X(4).
           03  FD-BANK-ACCOUNT     PIC 9(5).
           03  FD-CLIENT-NAME      PIC A(20).
           03  FD-BANK-BALANCE     PIC 9(6)V9(2).

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62509'.

       77  WS-FS-CLIENTS           PIC X(2)            VALUE ZEROS.

       77  WS-FMT-BANK-BALANCE     PIC ZZZ.ZZ9,99      VALUE ZEROS.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           PERFORM 0201-00-CENTRAL-PROCESSING
             UNTIL WS-FS-CLIENTS   EQUAL '10'.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           OPEN INPUT CLIENTS.

           EVALUATE WS-FS-CLIENTS
             WHEN '00'
               PERFORM 0301-00-READ-CLIENTS
             WHEN '35'
               DISPLAY ' CUSTOMER FILE NOT FOUND'
               MOVE 12             TO RETURN-CODE
               STOP RUN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0101-00-INITIAL'
                                    ' FILE STATUS: ' WS-FS-CLIENTS
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0101-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           MOVE FD-BANK-BALANCE    TO WS-FMT-BANK-BALANCE

           DISPLAY 'BRANCH.: ' FD-BANK-BRANCH.
           DISPLAY 'ACCOUNT: ' FD-BANK-ACCOUNT.
           DISPLAY 'NAME...: ' FD-CLIENT-NAME.
           DISPLAY 'BALANCE: ' WS-FMT-BANK-BALANCE.
           DISPLAY SPACES.

           PERFORM 0301-00-READ-CLIENTS.

       0201-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-READ-CLIENTS        SECTION.
      *----------------------------------------------------------------*

       0301-00-READ-CLIENTS.

           READ CLIENTS.

           EVALUATE WS-FS-CLIENTS
             WHEN '00'
               CONTINUE
             WHEN '10'
               DISPLAY ' END OF FILE'
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0301-00-READ-CLIENTS'
                                    ' FILE STATUS: ' WS-FS-CLIENTS
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0301-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           CLOSE CLIENTS.

           EVALUATE WS-FS-CLIENTS
             WHEN '00'
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0901-00-FINAL'
                                    ' FILE STATUS: ' WS-FS-CLIENTS
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.