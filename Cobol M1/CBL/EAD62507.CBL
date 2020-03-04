      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62507.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62507                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : CALCULATE FINANCIAL INVESTMENT               *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62507'.

       77  WS-BALANCE              PIC 9(7)V9(2)       VALUE ZEROS.
       77  WS-DEPOSIT              PIC 9(5)V9(2)       VALUE ZEROS.
       77  WS-PERIOD               PIC 9(3)            VALUE ZEROS.
       77  WS-RATE                 PIC 9(1)V9(2)       VALUE ZEROS.
       77  WS-INCOME               PIC 9(5)V9(2)       VALUE ZEROS.

       77  WS-MONTH                PIC 9(3)            VALUE ZEROS.

       77  WS-FMT-BALANCE          PIC Z.ZZZ.ZZ9,99    VALUE ZEROS.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           ACCEPT WS-DEPOSIT       FROM SYSIN.
           ACCEPT WS-PERIOD        FROM SYSIN.
           ACCEPT WS-RATE          FROM SYSIN.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

           PERFORM 0101-00-CALC-INVEST  VARYING WS-MONTH FROM 1 BY 1
               UNTIL WS-MONTH      GREATER WS-PERIOD.

           MOVE WS-BALANCE         TO WS-FMT-BALANCE.
           DISPLAY SPACES.
           DISPLAY ' BALANCE AFTER ' WS-PERIOD ' MONTHS EQUAL '
                                                       WS-FMT-BALANCE.

           DISPLAY '*----------------------------------------------*'.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-CALC-INVEST         SECTION.
      *----------------------------------------------------------------*

       0101-00-CALC-INVEST.

           COMPUTE WS-INCOME = (WS-BALANCE * WS-RATE) / 100.
           ADD WS-INCOME       TO WS-BALANCE.
           ADD WS-DEPOSIT      TO WS-BALANCE.

           MOVE WS-BALANCE     TO WS-FMT-BALANCE.
           DISPLAY ' BALANCE IN THE MONTH ' WS-MONTH ' EQUAL '
                                                       WS-FMT-BALANCE.

       0101-00-EXIT.
           EXIT.