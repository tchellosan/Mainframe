      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62502.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62502                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : DISPLAY GREETING, DATE AND TIME              *
      *                                                                *
      *================================================================*
       ENVIRONMENT                 DIVISION.
      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62502'.

       01  WS-SYS-DATE.
           03  WS-YEAR             PIC 9(2)            VALUE ZEROS.
           03  WS-MONTH            PIC 9(2)            VALUE ZEROS.
           03  WS-DAY              PIC 9(2)            VALUE ZEROS.

       01  WS-DATE-FORMAT.
           03  WS-DAY              PIC 9(2)            VALUE ZEROS.
           03  FILLER              PIC X(1)            VALUE '/'.
           03  WS-MONTH            PIC 9(2)            VALUE ZEROS.
           03  FILLER              PIC X(1)            VALUE '/'.
           03  FILLER              PIC 9(2)            VALUE 20.
           03  WS-YEAR             PIC 9(2)            VALUE ZEROS.

       01  WS-SYS-TIME.
           03  WS-HOUR             PIC 9(2)            VALUE ZEROS.
           03  WS-MINUTE           PIC 9(2)            VALUE ZEROS.
           03  WS-SECOND           PIC 9(2)            VALUE ZEROS.
           03  FILLER              PIC 9(2)            VALUE ZEROS.

       01  WS-TIME-FORMAT.
           03  WS-HOUR             PIC 9(2)            VALUE ZEROS.
           03  FILLER              PIC X(1)            VALUE ':'.
           03  WS-MINUTE           PIC 9(2)            VALUE ZEROS.
           03  FILLER              PIC X(1)            VALUE ':'.
           03  WS-SECOND           PIC 9(2)            VALUE ZEROS.

       77 WS-NAME                  PIC A(60)           VALUE SPACES.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           ACCEPT WS-NAME          FROM SYSIN.

           ACCEPT WS-SYS-DATE      FROM DATE.
           MOVE CORRESPONDING  WS-SYS-DATE
                                   TO WS-DATE-FORMAT

           ACCEPT WS-SYS-TIME      FROM TIME.
           MOVE CORRESPONDING  WS-SYS-TIME
                                   TO WS-TIME-FORMAT


           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY ' NAME...: ' WS-NAME.
           DISPLAY ' SYSDATE: ' WS-DATE-FORMAT.
           DISPLAY ' SYSTIME: ' WS-TIME-FORMAT.
           DISPLAY '*----------------------------------------------*'.

           STOP RUN.

       0001-00-EXIT.
           EXIT.