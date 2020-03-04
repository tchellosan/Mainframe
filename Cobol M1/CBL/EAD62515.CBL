      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62515.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62515                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : GET NAME OF MONTH AND DAY OF WEEK            *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62515'.

       01  WS-MONTH-OF-YEAR.
           03  FILLER              PIC X(9)            VALUE 'JANUARY'.
           03  FILLER              PIC X(9)            VALUE 'FEBRUARY'.
           03  FILLER              PIC X(9)            VALUE 'MARCH'.
           03  FILLER              PIC X(9)            VALUE 'APRIL'.
           03  FILLER              PIC X(9)            VALUE 'MAY'.
           03  FILLER              PIC X(9)            VALUE 'JUNE'.
           03  FILLER              PIC X(9)            VALUE 'JULY'.
           03  FILLER              PIC X(9)            VALUE 'AUGUST'.
           03  FILLER              PIC X(9)            VALUE
                                                       'SEPTEMBER'.
           03  FILLER              PIC X(9)            VALUE 'OCTOBER'.
           03  FILLER              PIC X(9)            VALUE 'NOVEMBER'.
           03  FILLER              PIC X(9)            VALUE 'DECEMBER'.
       01  FILLER                  REDEFINES WS-MONTH-OF-YEAR.
           03  WS-NAME-MONTH       PIC X(9) OCCURS 12 TIMES.

       01  WS-DAYS-OF-WEEK.
           03  FILLER              PIC X(9)            VALUE 'MONDAY'.
           03  FILLER              PIC X(9)            VALUE 'TUESDAY'.
           03  FILLER              PIC X(9)            VALUE
                                                       'WEDNESDAY'.
           03  FILLER              PIC X(9)            VALUE 'THURSDAY'.
           03  FILLER              PIC X(9)            VALUE 'FRIDAY'.
           03  FILLER              PIC X(9)            VALUE 'SATURDAY'.
           03  FILLER              PIC X(9)            VALUE 'SUNDAY'.
       01  FILLER                  REDEFINES WS-DAYS-OF-WEEK.
           03  WS-NAME-DAY-OF-WEEK PIC X(9) OCCURS 7 TIMES.

      *----------------------------------------------------------------*
       LINKAGE                     SECTION.

       01  LKG-COMMAREA.
           03  LKG-INPUT.
               05  LKG-MONTH       PIC 9(2).
               05  LKG-DAY         PIC 9(1).
           03  LKG-OUTPUT.
               05  LKG-NAME-MONTH  PIC X(9).
               05  LKG-NAME-DAY-WEEK
                                   PIC X(9).

      *================================================================*
       PROCEDURE                   DIVISION USING LKG-COMMAREA.
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

           CONTINUE.

       0101-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

       0201-00-CENTRAL-PROCESSING.

           MOVE WS-NAME-MONTH(LKG-MONTH)
                                   TO LKG-NAME-MONTH.
           MOVE WS-NAME-DAY-OF-WEEK(LKG-DAY)
                                   TO LKG-NAME-DAY-WEEK.

       0201-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0900-00-FINAL               SECTION.
      *----------------------------------------------------------------*

       0901-00-FINAL.

           GOBACK.

       0901-00-EXIT.
           EXIT.