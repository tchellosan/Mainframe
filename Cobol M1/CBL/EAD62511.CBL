      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62511.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62511                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : PRINT CUSTOMER REPORTS                       *
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

           SELECT CLIENTSR         ASSIGN TO DA-S-CLIENTSR
               FILE STATUS         IS WS-FS-CLIENTSR.

           SELECT REPORTC          ASSIGN TO DA-S-REPORTC.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

       FD  CLIENTSR
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-CLIENTSR.
           03  FD-CLIENT-KEY.
               05  FD-BANK-BRANCH  PIC X(4).
               05  FD-BANK-ACCOUNT PIC 9(5).
           03  FD-CLIENT-NAME      PIC A(20).
           03  FD-BANK-BALANCE     PIC 9(6)V9(2).

       FD  REPORTC
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-REPORTC             PIC X(50).

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62511'.

       01  WS-HEADER-1.
           03 FILLER               PIC X(3)            VALUE SPACES.
           03 FILLER               PIC X(15)           VALUE
           'CUSTOMER REPORT'.
           03 FILLER               PIC X(15)           VALUE SPACES.
           03 FILLER               PIC X(5)            VALUE
           'PAGE:'.
           03 FILLER               PIC X(1)            VALUE SPACES.
           03 WS-H-NUMBER-PAGE     PIC 9(3)            VALUE ZEROS.

       01  WS-HEADER-2.
           03 FILLER               PIC X(7)            VALUE SPACES.
           03 FILLER               PIC X(13)           VALUE
           'BANK BRANCH: '.
           03 WS-H-BANK-BRANCH     PIC X(4)            VALUE SPACES.

       01  WS-HEADER-3.
           03 FILLER               PIC X(7)            VALUE
           'ACCOUNT'.
           03 FILLER               PIC X(1)            VALUE SPACES.
           03 FILLER               PIC X(4)            VALUE
           'NAME'.
           03 FILLER               PIC X(20)           VALUE SPACES.
           03 FILLER               PIC X(7)            VALUE
           'BALANCE'.

       01  WS-DETAIL-1.
           03 FILLER               PIC X(2)            VALUE SPACES.
           03 WS-D-ACCOUNT         PIC 9(5)            VALUE ZEROS.
           03 FILLER               PIC X(1)            VALUE SPACES.
           03 WS-D-NAME            PIC A(20)           VALUE SPACES.
           03 FILLER               PIC X(1)            VALUE SPACES.
           03 WS-D-BALANCE         PIC ZZZ.ZZ9,99      VALUE ZEROS.

       01  WS-FOOTER-1.
           03 FILLER               PIC X(17)           VALUE
           'BANK BRANCH TOTAL'.
           03 FILLER               PIC X(1)            VALUE SPACES.
           03 WS-F-BANK-BRANCH     PIC X(4)            VALUE SPACES.
           03 FILLER               PIC X(1)            VALUE SPACES.
           03 FILLER               PIC X(2)            VALUE
           '=>'.
           03 FILLER               PIC X(1)            VALUE SPACES.
           03 WS-F-TOTAL-BALANCE   PIC ZZ.ZZZ.ZZ9,99   VALUE ZEROS.

       77  WS-FS-CLIENTSR          PIC X(2)            VALUE ZEROS.

       77  WS-READ-CLIENTSR        PIC 9(3)            VALUE ZEROS.

       77  WS-FMT-AMOUNT           PIC ZZ9             VALUE ZEROS.

       77  WS-CURRENT-BRANCH       PIC X(4)            VALUE ZEROS.
       77  WS-TOTAL-BALANCE        PIC 9(8)V9(2)       VALUE ZEROS.
       77  WS-PRINTED-DETAILS      PIC 9(2)            VALUE 99.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           PERFORM 0201-00-CENTRAL-PROCESSING
             UNTIL WS-FS-CLIENTSR  EQUAL '10'.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           PERFORM 0102-00-OPEN-CLIENTSR.
           PERFORM 0103-00-OPEN-REPORTC.

       0101-00-EXIT.
           EXIT.

       0102-00-OPEN-CLIENTSR.

           OPEN INPUT CLIENTSR.

           EVALUATE WS-FS-CLIENTSR
             WHEN '00'
               PERFORM 0301-00-READ-CLIENTSR
               IF  WS-READ-CLIENTSR
                                   GREATER ZEROS
                   MOVE FD-BANK-BRANCH TO WS-CURRENT-BRANCH
               END-IF
             WHEN '35'
               DISPLAY ' CUSTOMER FILE NOT FOUND'
               MOVE 12             TO RETURN-CODE
               STOP RUN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0102-00-OPEN-CLIENTSR'
                                    ' FILE STATUS: ' WS-FS-CLIENTSR
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0102-00-EXIT.
           EXIT.

       0103-00-OPEN-REPORTC.

           OPEN OUTPUT REPORTC.

       0103-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           PERFORM 0202-PRINT-DETAIL.
           PERFORM 0301-00-READ-CLIENTSR.

       0201-00-EXIT.
           EXIT.

       0202-PRINT-DETAIL.

           IF  FD-BANK-BRANCH      NOT EQUAL WS-CURRENT-BRANCH
               PERFORM 0203-PRINT-FOOTER
           END-IF.

           IF  WS-PRINTED-DETAILS  NOT LESS 5
               PERFORM 0204-PRINT-HEADER
           END-IF.

           MOVE FD-BANK-ACCOUNT    TO WS-D-ACCOUNT.
           MOVE FD-CLIENT-NAME     TO WS-D-NAME.
           MOVE FD-BANK-BALANCE    TO WS-D-BALANCE.

           WRITE REG-REPORTC       FROM WS-DETAIL-1.

           ADD 1                   TO WS-PRINTED-DETAILS.
           ADD FD-BANK-BALANCE     TO WS-TOTAL-BALANCE.

       0202-00-EXIT.
           EXIT.

       0203-PRINT-FOOTER.

           MOVE WS-CURRENT-BRANCH  TO WS-F-BANK-BRANCH.
           MOVE WS-TOTAL-BALANCE   TO WS-F-TOTAL-BALANCE.

           WRITE REG-REPORTC       FROM WS-FOOTER-1
                                   AFTER 2 LINES.

           MOVE FD-BANK-BRANCH     TO WS-CURRENT-BRANCH.
           MOVE 99                 TO WS-PRINTED-DETAILS.
           MOVE ZEROS              TO WS-TOTAL-BALANCE.

       0203-00-EXIT.
           EXIT.

       0204-PRINT-HEADER.

           ADD 1                   TO WS-H-NUMBER-PAGE.
           WRITE REG-REPORTC       FROM WS-HEADER-1
                                   AFTER PAGE.

           MOVE FD-BANK-BRANCH     TO WS-H-BANK-BRANCH.
           WRITE REG-REPORTC       FROM WS-HEADER-2.

           WRITE REG-REPORTC       FROM WS-HEADER-3
                                   AFTER 2 LINES.

           MOVE ZEROS              TO WS-PRINTED-DETAILS.

       0204-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-READ                SECTION.
      *----------------------------------------------------------------*

       0301-00-READ-CLIENTSR.

           READ CLIENTSR.

           EVALUATE WS-FS-CLIENTSR
             WHEN '00'
               ADD 1               TO WS-READ-CLIENTSR
             WHEN '10'
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0301-00-READ-CLIENTSR'
                                    ' FILE STATUS: ' WS-FS-CLIENTSR
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0301-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           PERFORM 0203-PRINT-FOOTER.

           PERFORM 0902-00-CLOSE-FILES.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY '*                                              *'.
           MOVE WS-READ-CLIENTSR   TO WS-FMT-AMOUNT
           DISPLAY '*  READ  CLIENTSR: ' WS-FMT-AMOUNT
                                         '                         *'.
           DISPLAY '*                                              *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.

       0902-00-CLOSE-FILES.

           CLOSE CLIENTSR
                 REPORTC.

       0902-00-EXIT.
           EXIT.