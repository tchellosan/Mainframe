      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62503.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               FEB/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62503                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : ARITHMETIC OPERATIONS [+, -, *, /, (), **]   *
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

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62503'.

       77  WS-CONST                PIC 9(2)V9(2)       VALUE ZEROS.

       77  WS-NUM-1                PIC 9(2)V9(2)       VALUE ZEROS.
       77  WS-NUM-2                PIC 9(2)V9(2)       VALUE ZEROS.

       77  WS-RES-ADD-TO           PIC S9(3)V9(2)      VALUE ZEROS.
       77  WS-RES-ADD-GIVE         PIC S9(3)V9(2)      VALUE ZEROS.

       77  WS-RES-SUB-FROM         PIC S9(3)V9(2)      VALUE ZEROS.
       77  WS-RES-SUB-FROM-GIVE    PIC S9(3)V9(2)      VALUE ZEROS.

       77  WS-RES-MULTIPLY         PIC S9(3)V9(2)      VALUE ZEROS.

       77  WS-RES-DIVIDE           PIC S9(3)V9(2)      VALUE ZEROS.
       77  WS-RES-DIVIDE-INTO      PIC S9(3)V9(2)      VALUE ZEROS.

       77  WS-RES-DIVIDE-INTEGER   PIC S9(3)           VALUE ZEROS.
       77  WS-RES-DIVIDE-REM       PIC S9(3)V9(2)      VALUE ZEROS.

       77  WS-RES-COMPUTE-AVG      PIC S9(3)V9(2)      VALUE ZEROS.

       77  WS-FMT-NUM-1            PIC Z9,99           VALUE ZEROS.
       77  WS-FMT-NUM-2            PIC Z9,99           VALUE ZEROS.
       77  WS-FMT-RESULT           PIC -ZZ9,99         VALUE ZEROS.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

       0001-00-MAIN.

           ACCEPT WS-NUM-1         FROM SYSIN.
           ACCEPT WS-NUM-2         FROM SYSIN.

           MOVE WS-NUM-1           TO WS-FMT-NUM-1.
           MOVE WS-NUM-2           TO WS-FMT-NUM-2.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

           PERFORM 0101-00-ADD-TO.
           PERFORM 0102-00-ADD-GIVING.

           PERFORM 0201-00-SUBTRACT.
           PERFORM 0202-00-SUBTRACT-GIVING.

           PERFORM 0301-00-MULTIPLY.

           PERFORM 0401-00-DIVIDE.
           PERFORM 0402-00-DIVIDE-INTO.
           PERFORM 0403-00-DIVIDE-REMAINDER.

           PERFORM 0501-00-COMPUTE-AVERAGE.

           DISPLAY '*----------------------------------------------*'.

           STOP RUN.

       0001-99-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0100-00-ADD                 SECTION.
      *----------------------------------------------------------------*

       0101-00-ADD-TO.

           ADD WS-NUM-1
               WS-NUM-2            TO WS-RES-ADD-TO.

           MOVE WS-RES-ADD-TO      TO WS-FMT-RESULT.
           DISPLAY ' RES-ADD-TO.....: '
                WS-FMT-NUM-1  ' + '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.

       0101-00-EXIT.
           EXIT.

       0102-00-ADD-GIVING.

           ADD WS-NUM-1
               WS-NUM-2            GIVING WS-RES-ADD-GIVE.

           MOVE WS-RES-ADD-GIVE    TO WS-FMT-RESULT.
           DISPLAY ' RES-ADD-GIVE...: '
                WS-FMT-NUM-1  ' + '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.

       0102-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0200-00-SUBTRACT            SECTION.
      *----------------------------------------------------------------*

       0201-00-SUBTRACT.

           MOVE WS-NUM-1           TO WS-RES-SUB-FROM.
           SUBTRACT WS-NUM-2
                    WS-CONST       FROM WS-RES-SUB-FROM.

           DISPLAY '*'.

           MOVE WS-RES-SUB-FROM    TO WS-FMT-RESULT.
           DISPLAY ' RES-SUB-FROM...: '
                WS-FMT-NUM-1  ' - '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.

       0201-00-EXIT.
           EXIT.

       0202-00-SUBTRACT-GIVING.

           SUBTRACT WS-NUM-2
                    WS-CONST       FROM WS-NUM-1
                                   GIVING WS-RES-SUB-FROM-GIVE.


           MOVE WS-RES-SUB-FROM-GIVE
                                   TO WS-FMT-RESULT.
           DISPLAY ' RES-SUB-GIVE...: '
                WS-FMT-NUM-1  ' - '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.

       0202-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0300-00-MULTIPLY            SECTION.
      *----------------------------------------------------------------*

       0301-00-MULTIPLY.

           DISPLAY '*'.
           MULTIPLY WS-NUM-1       BY WS-NUM-2
                                   GIVING WS-RES-MULTIPLY ROUNDED
                   ON SIZE ERROR DISPLAY ' FIELD OVERFLOW'
               NOT ON SIZE ERROR DISPLAY ' NOT FIELD OVERFLOW'
           END-MULTIPLY.

           MOVE WS-RES-MULTIPLY
                                   TO WS-FMT-RESULT.
           DISPLAY ' RES-MULTIPLY...: '
                WS-FMT-NUM-1  ' * '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.

       0301-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0400-00-DIVIDE              SECTION.
      *----------------------------------------------------------------*

       0401-00-DIVIDE.

           DISPLAY '*'.
           DIVIDE WS-NUM-1         BY WS-NUM-2
                                   GIVING WS-RES-DIVIDE ROUNDED.

           MOVE WS-RES-DIVIDE      TO WS-FMT-RESULT.
           DISPLAY ' RES-DIVIDE.....: '
                WS-FMT-NUM-1  ' / '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.

       0401-00-EXIT.
           EXIT.

       0402-00-DIVIDE-INTO.

           MOVE WS-NUM-1           TO WS-RES-DIVIDE-INTO.
           DIVIDE WS-NUM-2         INTO WS-RES-DIVIDE-INTO ROUNDED.

           MOVE WS-RES-DIVIDE-INTO
                                   TO WS-FMT-RESULT.
           DISPLAY ' RES-DIVIDE-INTO: '
                WS-FMT-NUM-1  ' / '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.

       0402-00-EXIT.
           EXIT.

       0403-00-DIVIDE-REMAINDER.

           DISPLAY '*'.
           DIVIDE WS-NUM-1         BY WS-NUM-2
                                   GIVING WS-RES-DIVIDE-INTEGER
                                   REMAINDER WS-RES-DIVIDE-REM.

           MOVE WS-RES-DIVIDE-INTEGER
                                   TO WS-FMT-RESULT.
           DISPLAY ' RES-DIVIDE-REM.: '
                WS-FMT-NUM-1  ' / '  WS-FMT-NUM-2 ' = ' WS-FMT-RESULT.
           MOVE WS-RES-DIVIDE-REM
                                   TO WS-FMT-RESULT.
           DISPLAY ' REMAINDER......: ' WS-FMT-RESULT.

       0403-00-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0500-00-COMPUTE             SECTION.
      *----------------------------------------------------------------*

       0501-00-COMPUTE-AVERAGE.

           DISPLAY '*'.
           COMPUTE WS-RES-COMPUTE-AVG = (WS-NUM-1 + WS-NUM-2) / 2.

           MOVE WS-RES-COMPUTE-AVG
                                   TO WS-FMT-RESULT.
           DISPLAY ' COMPUTE..: '
            '(' WS-FMT-NUM-1  ' + '  WS-FMT-NUM-2 ') / 2'
                                                  ' = ' WS-FMT-RESULT.

       0501-00-EXIT.
           EXIT.