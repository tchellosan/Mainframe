      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62514.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62514                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : DISPLAY NAME OF MONTH AND DAY OF WEEK        *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62514'.

       01  WS-SYS-DATE.
           03  WS-YEAR             PIC 9(2)            VALUE ZEROS.
           03  WS-MONTH            PIC 9(2)            VALUE ZEROS.
           03  WS-DAY              PIC 9(2)            VALUE ZEROS.

       01  WS-SYS-DAY-OF-WEEK.
           03  WS-DAY              PIC 9(1)            VALUE ZEROS.

       01  WS-COMMAREA.
           03  WS-INPUT.
               05  WS-MONTH        PIC 9(2)            VALUE ZEROS.
               05  WS-DAY          PIC 9(1)            VALUE ZEROS.
           03  WS-OUTPUT.
               05  WS-NAME-MONTH   PIC X(9)            VALUE SPACES.
               05  WS-NAME-DAY-WEEK
                                   PIC X(9)            VALUE SPACES.

       77  WS-EAD62515             PIC X(8)            VALUE 'EAD62515'.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           PERFORM 0101-00-INITIAL.

           PERFORM 0201-00-CENTRAL-PROCESSING.

           PERFORM 0901-00-FINAL.

           STOP RUN.

       0001-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

       0101-00-INITIAL.

           ACCEPT WS-SYS-DATE      FROM DATE.
           ACCEPT WS-SYS-DAY-OF-WEEK
                                   FROM DAY-OF-WEEK.

       0101-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           MOVE 'EAD62515'      TO WS-EAD62515.

           MOVE WS-MONTH OF WS-SYS-DATE
                                TO WS-MONTH OF WS-INPUT.
           MOVE WS-DAY OF WS-SYS-DAY-OF-WEEK
                                TO WS-DAY OF WS-INPUT.

           CALL WS-EAD62515     USING WS-COMMAREA.

       0201-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.
           DISPLAY '*                                              *'.
           DISPLAY '* ' WS-NAME-MONTH ', ' WS-DAY OF WS-SYS-DATE
             ' OF 20' WS-YEAR ', ' WS-NAME-DAY-WEEK '             *'.
           DISPLAY '*                                              *'.
           DISPLAY '*----------------------------------------------*'.

       0901-00-EXIT.
           EXIT.