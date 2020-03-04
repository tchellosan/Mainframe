      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62504.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62504                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : FIND THE LARGEST AMONG 3 NUMBERS             *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62504'.

       77  WS-NUM-1                PIC 9(2)            VALUE ZEROS.
       77  WS-NUM-2                PIC 9(2)            VALUE ZEROS.
       77  WS-NUM-3                PIC 9(2)            VALUE ZEROS.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           ACCEPT WS-NUM-1         FROM SYSIN.
           ACCEPT WS-NUM-2         FROM SYSIN.
           ACCEPT WS-NUM-3         FROM SYSIN.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

           IF  WS-NUM-1            GREATER THAN WS-NUM-2
               IF  WS-NUM-1        GREATER THAN WS-NUM-3
                   DISPLAY ' THE LARGEST: ' WS-NUM-1
               ELSE
                   DISPLAY ' THE LARGEST: ' WS-NUM-3
               END-IF
           ELSE
               IF  WS-NUM-2        GREATER THAN WS-NUM-3
                   DISPLAY ' THE LARGEST: ' WS-NUM-2
               ELSE
                   DISPLAY ' THE LARGEST: ' WS-NUM-3
               END-IF
           END-IF.

           DISPLAY '*----------------------------------------------*'.

           STOP RUN.

       0001-00-EXIT.
           EXIT.