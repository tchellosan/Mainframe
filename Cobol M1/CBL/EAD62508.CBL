      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62508.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62508                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : CALCULATE DEBT REDEMPTION                    *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62508'.

       77  WS-DEBT                 PIC 9(7)V9(2)       VALUE ZEROS.
       77  WS-PAYMENT              PIC 9(5)V9(2)       VALUE ZEROS.
       77  WS-RATE                 PIC 9(1)V9(2)       VALUE ZEROS.
       77  WS-INTEREST             PIC 9(5)V9(2)       VALUE ZEROS.

       77  WS-MONTH                PIC 9(3)            VALUE ZEROS.

       77  WS-FMT-DEBT             PIC Z.ZZZ.ZZ9,99    VALUE ZEROS.
       77  WS-FMT-PAYMENT          PIC ZZ.ZZ9,99       VALUE ZEROS.
       77  WS-FMT-INTEREST         PIC ZZ.ZZ9,99       VALUE ZEROS.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           ACCEPT WS-DEBT          FROM SYSIN.
           ACCEPT WS-PAYMENT       FROM SYSIN.
           ACCEPT WS-RATE          FROM SYSIN.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

           PERFORM 0101-00-CALC-REDEMPTION
               UNTIL WS-DEBT       EQUAL ZEROS.

           DISPLAY SPACES.
           DISPLAY ' THE DEBT HAS BEEN PAID IN ' WS-MONTH ' MONTHS'

           DISPLAY '*----------------------------------------------*'.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-CALC-REDEMPTION     SECTION.
      *----------------------------------------------------------------*

       0101-00-CALC-REDEMPTION.

           COMPUTE WS-INTEREST = (WS-DEBT * WS-RATE) / 100.

           IF  WS-INTEREST         NOT LESS WS-PAYMENT
               DISPLAY ' PAYMENT AMOUNT UNDER THE CALCULATED INTEREST'
               STOP RUN
           END-IF.

           ADD WS-INTEREST         TO WS-DEBT.

           IF  WS-DEBT             LESS WS-PAYMENT
               MOVE WS-DEBT        TO WS-PAYMENT
           END-IF.

           SUBTRACT WS-PAYMENT     FROM WS-DEBT.
           ADD 1                   TO WS-MONTH.

           MOVE WS-DEBT            TO WS-FMT-DEBT.
           MOVE WS-INTEREST        TO WS-FMT-INTEREST.
           MOVE WS-PAYMENT         TO WS-FMT-PAYMENT.

           DISPLAY ' MONTH: ' WS-MONTH ' INTEREST: ' WS-FMT-INTEREST
                   ' PAYMENT: ' WS-FMT-PAYMENT ' DEBT: ' WS-FMT-DEBT.

       0101-00-EXIT.
           EXIT.