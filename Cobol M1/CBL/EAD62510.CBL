      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62510.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62510                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : BALANCE LINE: CREDIT AND DEBIT RELEASES      *
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

           SELECT CLIENTSO         ASSIGN TO DA-S-CLIENTSO
               FILE STATUS         IS WS-FS-CLIENTSO.

           SELECT RELEASES         ASSIGN TO DA-S-RELEASES
               FILE STATUS         IS WS-FS-RELEASES.

           SELECT CLIENTSN         ASSIGN TO DA-S-CLIENTSN
               FILE STATUS         IS WS-FS-CLIENTSN.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

       FD  CLIENTSO
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-CLIENTSO.
           03  FD-CLIENT-KEY.
               05  FD-BANK-BRANCH  PIC X(4).
               05  FD-BANK-ACCOUNT PIC 9(5).
           03  FD-CLIENT-NAME      PIC A(20).
           03  FD-BANK-BALANCE     PIC 9(6)V9(2).

       FD  RELEASES
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-RELEASES.
           03  FD-RELEASE-KEY.
               05  FD-BANK-BRANCH  PIC X(4).
               05  FD-BANK-ACCOUNT PIC 9(5).
           03  FD-DOC-NUMBER       PIC 9(4).
           03  FD-RELEASE-TYPE     PIC A(1).
           03  FD-RELEASE-VALUE    PIC 9(6)V9(2).

       FD  CLIENTSN
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.

       01  REG-CLIENTSN.
           03  FD-CLIENT-KEY.
               05  FD-BANK-BRANCH  PIC X(4).
               05  FD-BANK-ACCOUNT PIC 9(5).
           03  FD-CLIENT-NAME      PIC A(20).
           03  FD-BANK-BALANCE     PIC 9(6)V9(2).

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62510'.

       77  WS-FS-CLIENTSO          PIC X(2)            VALUE ZEROS.
       77  WS-FS-RELEASES          PIC X(2)            VALUE ZEROS.
       77  WS-FS-CLIENTSN          PIC X(2)            VALUE ZEROS.

       77  WS-WRITE-CLIENTSN       PIC 9(3)            VALUE ZEROS.
       77  WS-READ-CLIENTSO        PIC 9(3)            VALUE ZEROS.
       77  WS-READ-RELEASES        PIC 9(3)            VALUE ZEROS.

       01  WS-RELEASE-TYPE         PIC A(1)            VALUE SPACES.
           88  WS-CREDIT                               VALUE 'C'.
           88  WS-DEBIT                                VALUE 'D'.

       77  WS-FMT-VALUE            PIC ZZZ.ZZ9,99      VALUE ZEROS.
       77  WS-FMT-AMOUNT           PIC ZZ9             VALUE ZEROS.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           PERFORM 0201-00-CENTRAL-PROCESSING
             UNTIL WS-FS-CLIENTSO  EQUAL '10' AND
                   WS-FS-RELEASES  EQUAL '10'.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           PERFORM 0102-00-OPEN-CLIENTSO.
           PERFORM 0103-00-OPEN-RELEASES.
           PERFORM 0104-00-OPEN-CLIENTSN.

       0101-00-EXIT.
           EXIT.

       0102-00-OPEN-CLIENTSO.

           OPEN INPUT CLIENTSO.

           EVALUATE WS-FS-CLIENTSO
             WHEN '00'
               PERFORM 0301-00-READ-CLIENTSO
             WHEN '35'
               DISPLAY ' CUSTOMER FILE NOT FOUND'
               MOVE 12             TO RETURN-CODE
               STOP RUN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0102-00-OPEN-CLIENTSO'
                                    ' FILE STATUS: ' WS-FS-CLIENTSO
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0102-00-EXIT.
           EXIT.

       0103-00-OPEN-RELEASES.

           OPEN INPUT RELEASES.

           EVALUATE WS-FS-RELEASES
             WHEN '00'
               PERFORM 0302-00-READ-RELEASES
             WHEN '35'
               DISPLAY ' RELEASES FILE NOT FOUND'
               MOVE 12             TO RETURN-CODE
               STOP RUN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0103-00-OPEN-RELEASES'
                                    ' FILE STATUS: ' WS-FS-RELEASES
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0103-00-EXIT.
           EXIT.

       0104-00-OPEN-CLIENTSN.

           OPEN OUTPUT CLIENTSN.

           EVALUATE WS-FS-CLIENTSN
             WHEN '00'
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0104-00-OPEN-CLIENTSN'
                                    ' FILE STATUS: ' WS-FS-CLIENTSN
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0104-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           EVALUATE TRUE
             WHEN FD-CLIENT-KEY OF REG-CLIENTSO
                                   LESS FD-RELEASE-KEY
               PERFORM 0202-WRITE-CLIENTSN
               PERFORM 0301-00-READ-CLIENTSO

             WHEN FD-CLIENT-KEY OF REG-CLIENTSO
                                   EQUAL FD-RELEASE-KEY
               PERFORM 0203-MAKE-RELEASE
               PERFORM 0302-00-READ-RELEASES

             WHEN OTHER
               DISPLAY ' =======> RELEASE KEY INVALID =>'
                                 ' KEY: ' FD-RELEASE-KEY
                                 ' (DOCUMENT NUMBER: ' FD-DOC-NUMBER ')'
               PERFORM 0302-00-READ-RELEASES

           END-EVALUATE.

       0201-00-EXIT.
           EXIT.

       0202-WRITE-CLIENTSN.

           MOVE FD-BANK-BALANCE OF REG-CLIENTSO
                                   TO WS-FMT-VALUE.
           DISPLAY '===> FINAL BALANCE..: ' WS-FMT-VALUE.
           DISPLAY SPACES.

           MOVE REG-CLIENTSO       TO REG-CLIENTSN.

           WRITE REG-CLIENTSN.

           EVALUATE WS-FS-CLIENTSN
             WHEN '00'
               ADD 1               TO WS-WRITE-CLIENTSN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0202-WRITE-CLIENTSN'
                                    ' FILE STATUS: ' WS-FS-CLIENTSN
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0202-00-EXIT.
           EXIT.

       0203-MAKE-RELEASE.

           MOVE FD-RELEASE-TYPE    TO WS-RELEASE-TYPE

           EVALUATE TRUE
             WHEN WS-CREDIT
               ADD FD-RELEASE-VALUE
                                   TO FD-BANK-BALANCE OF REG-CLIENTSO

               MOVE FD-RELEASE-VALUE
                                   TO WS-FMT-VALUE
               DISPLAY ' =======> CREDIT: ' WS-FMT-VALUE
             WHEN WS-DEBIT
               IF  FD-BANK-BALANCE OF REG-CLIENTSO
                                   NOT LESS FD-RELEASE-VALUE
                   SUBTRACT FD-RELEASE-VALUE
                                   FROM FD-BANK-BALANCE OF REG-CLIENTSO

                   MOVE FD-RELEASE-VALUE
                                   TO WS-FMT-VALUE
                   DISPLAY ' =======> DEBIT.: ' WS-FMT-VALUE
               ELSE
                   MOVE FD-RELEASE-VALUE
                                   TO WS-FMT-VALUE
                   DISPLAY ' =======> DEBIT.: ' WS-FMT-VALUE
                           ' => INSUFFICIENT BALANCE '
                                 '(DOCUMENT NUMBER: ' FD-DOC-NUMBER ')'
               END-IF

             WHEN OTHER
               DISPLAY ' RELEASE TYPE INVALID ==> '
                                    ' RELEASE KEY: ' FD-RELEASE-KEY
                                    ' DOCUMENT NUMBER: ' FD-DOC-NUMBER
                                    ' RELEASE TYPE: ' FD-RELEASE-TYPE

           END-EVALUATE.

       0203-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-READ                SECTION.
      *----------------------------------------------------------------*

       0301-00-READ-CLIENTSO.

           READ CLIENTSO.

           EVALUATE WS-FS-CLIENTSO
             WHEN '00'
               MOVE FD-BANK-BALANCE OF REG-CLIENTSO
                                   TO WS-FMT-VALUE
               DISPLAY FD-BANK-BRANCH OF REG-CLIENTSO SPACES
                       FD-BANK-ACCOUNT OF REG-CLIENTSO SPACES
                       FD-CLIENT-NAME OF REG-CLIENTSO
               DISPLAY '===> INITIAL BALANCE: ' WS-FMT-VALUE

               ADD 1               TO WS-READ-CLIENTSO
             WHEN '10'
               MOVE HIGH-VALUES    TO FD-CLIENT-KEY OF REG-CLIENTSO
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0301-00-READ-CLIENTSO'
                                    ' FILE STATUS: ' WS-FS-CLIENTSO
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0301-00-EXIT.
           EXIT.

       0302-00-READ-RELEASES.

           READ RELEASES.

           EVALUATE WS-FS-RELEASES
             WHEN '00'
               ADD 1               TO WS-READ-RELEASES
             WHEN '10'
               MOVE HIGH-VALUES    TO FD-RELEASE-KEY
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0302-00-READ-RELEASES'
                                    ' FILE STATUS: ' WS-FS-RELEASES
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0302-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           PERFORM 0902-00-CLOSE-FILES.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY '*                                              *'.
           MOVE WS-READ-CLIENTSO   TO WS-FMT-AMOUNT
           DISPLAY '*  READ  CLIENTSO: ' WS-FMT-AMOUNT
                                         '                         *'.
           MOVE WS-READ-RELEASES   TO WS-FMT-AMOUNT
           DISPLAY '*  READ  RELEASES: ' WS-FMT-AMOUNT
                                         '                         *'.
           MOVE WS-WRITE-CLIENTSN  TO WS-FMT-AMOUNT
           DISPLAY '*  WRITE CLIENTSN: ' WS-FMT-AMOUNT
                                         '                         *'.
           DISPLAY '*                                              *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.

       0902-00-CLOSE-FILES.

           CLOSE CLIENTSO
                 RELEASES.

           PERFORM 0903-00-CLOSE-CLIENTSN.

       0902-00-EXIT.
           EXIT.

       0903-00-CLOSE-CLIENTSN.

           CLOSE CLIENTSN.

           EVALUATE WS-FS-CLIENTSN
             WHEN '00'
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0903-00-CLOSE-CLIENTSN'
                                    ' FILE STATUS: ' WS-FS-CLIENTSN
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0903-00-EXIT.
           EXIT.