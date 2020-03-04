      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62505.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62505                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : DISPLAY VARIABLE WITH HIGHER VALUE           *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62505'.

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

           EVALUATE TRUE
               WHEN WS-NUM-1       GREATER WS-NUM-2 AND
                    WS-NUM-1       GREATER WS-NUM-3
                    DISPLAY ' THE LARGEST VARIABLE IS WS-NUM-1'
               WHEN WS-NUM-2       GREATER WS-NUM-1 AND
                    WS-NUM-2       GREATER WS-NUM-3
                    DISPLAY ' THE LARGEST VARIABLE IS WS-NUM-2'
               WHEN WS-NUM-3       GREATER WS-NUM-1 AND
                    WS-NUM-3       GREATER WS-NUM-2
                    DISPLAY ' THE LARGEST VARIABLE IS WS-NUM-3'
               WHEN WS-NUM-1       EQUAL WS-NUM-2 AND
                    WS-NUM-1       GREATER WS-NUM-3
                    DISPLAY
                    ' THE LARGEST VARIABLES ARE WS-NUM-1 AND WS-NUM-2'
               WHEN WS-NUM-1       EQUAL WS-NUM-3 AND
                    WS-NUM-1       GREATER WS-NUM-2
                    DISPLAY
                    ' THE LARGEST VARIABLES ARE WS-NUM-1 AND WS-NUM-3'
               WHEN WS-NUM-2       EQUAL WS-NUM-3 AND
                    WS-NUM-2       GREATER WS-NUM-1
                    DISPLAY
                    ' THE LARGEST VARIABLES ARE WS-NUM-2 AND WS-NUM-3'
               WHEN OTHER
                    DISPLAY
                    ' THE LARGEST VARIABLES ARE WS-NUM-1, WS-NUM-2 '
                    'AND WS-NUM-3'
           END-EVALUATE.

           DISPLAY '*----------------------------------------------*'.

           STOP RUN.

       0001-00-EXIT.
           EXIT.