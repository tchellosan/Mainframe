      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62506.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62506                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : CALCULATE THE CUBE FROM A NUMBER             *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62506'.

       77  WS-NUM-CALC             PIC 9(3)            VALUE ZEROS.

       77  WS-IND                  PIC 9(2)            VALUE ZEROS.

       77  WS-FIELD-OVERFLOW       PIC X(1)            VALUE SPACES.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

           PERFORM VARYING WS-IND  FROM 2 BY 1
               UNTIL WS-IND        GREATER 10

               MOVE WS-IND         TO WS-NUM-CALC

               PERFORM 2 TIMES
                   MULTIPLY WS-IND
                                   BY WS-NUM-CALC
                       ON SIZE ERROR MOVE 'Y' TO WS-FIELD-OVERFLOW
                   END-MULTIPLY
               END-PERFORM

               IF  WS-FIELD-OVERFLOW
                                   EQUAL 'Y'
                   DISPLAY ' NUMBER: ' WS-IND ' CUBE: FIELD-OVERFLOW'
                   MOVE SPACES     TO WS-FIELD-OVERFLOW
               ELSE
                   DISPLAY ' NUMBER: ' WS-IND ' CUBE: ' WS-NUM-CALC
               END-IF

           END-PERFORM.

           DISPLAY '*----------------------------------------------*'.

           STOP RUN.

       0001-00-EXIT.
           EXIT.