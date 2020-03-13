      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD62520.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMMER    : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAM       : EAD62520                                     *
      *   LANGUAGE      : COBOL                                        *
      *   TARGET        : READ VSAM FILE (ACCESS MODE SEQUENTIAL)      *
      *                                                                *
      *================================================================*
       ENVIRONMENT                 DIVISION.
      *================================================================*
       INPUT-OUTPUT                SECTION.

       FILE-CONTROL.

           SELECT VS001            ASSIGN TO VS001
               ORGANIZATION        IS INDEXED
               ACCESS MODE         IS SEQUENTIAL
               RECORD KEY          IS FD-VS001-KEY
               FILE STATUS         IS WS-FS-VS001.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

       FD  VS001.

       01  REG-VS001.
           05  FD-VS001-KEY.
               10  FD-ID-EMPLOYEE  PIC 9(3).
           05  FD-NAME             PIC X(20).
           05  FD-DEPT             PIC X(5).
           05  FD-SALARY           PIC 9(3)V9(2).

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

       77  WS-PROGRAM              PIC X(8)            VALUE 'EAD62520'.

       77  WS-FS-VS001             PIC X(2)            VALUE SPACES.
       77  WS-EOF                  PIC X(2)            VALUE '10'.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-00-MAIN                SECTION.
      *----------------------------------------------------------------*

           PERFORM 0100-00-INITIAL.

           PERFORM 0200-00-CENTRAL-PROCESSING
             UNTIL WS-FS-VS001     EQUAL WS-EOF.

           PERFORM 0300-00-FINAL.

      *----------------------------------------------------------------*
       0100-00-INITIAL             SECTION.
      *----------------------------------------------------------------*

           PERFORM 0501-00-OPEN-VS001.

           PERFORM 0502-00-READ-VS001.

           IF  WS-FS-VS001         EQUAL WS-EOF
               DISPLAY ' EMPTY FILE'
               PERFORM 0300-00-FINAL
           END-IF.

      *----------------------------------------------------------------*
       0200-00-CENTRAL-PROCESSING  SECTION.
      *----------------------------------------------------------------*

           DISPLAY 'FD-ID-EMPLOYEE: ' FD-ID-EMPLOYEE.
           DISPLAY 'FD-NAME.......: ' FD-NAME.
           DISPLAY 'FD-DEPT.......: ' FD-DEPT.
           DISPLAY 'FD-SALARY.....: ' FD-SALARY.
           DISPLAY '*----------------------------------------------*'.

           PERFORM 0502-00-READ-VS001.

      *----------------------------------------------------------------*
       0300-00-FINAL               SECTION.
      *----------------------------------------------------------------*

           PERFORM 0503-00-CLOSE-VS001.

           DISPLAY '*----------------------------------------------*'.
           DISPLAY '* ' WS-PROGRAM
                   ' PROGRAM SUCCESSFULLY EXECUTED       *'.
           DISPLAY '*----------------------------------------------*'.

           MOVE ZEROS              TO RETURN-CODE.

           STOP RUN.

      *----------------------------------------------------------------*
       0500-00-FILE-VS001          SECTION.
      *----------------------------------------------------------------*

       0501-00-OPEN-VS001.

           OPEN INPUT VS001.

           EVALUATE WS-FS-VS001
             WHEN '00'
               CONTINUE
             WHEN '35'
               DISPLAY ' VS001 NOT FOUND'
               MOVE 12             TO RETURN-CODE
               STOP RUN
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0501-00-OPEN-VS001'
                                    ' FILE STATUS: ' WS-FS-VS001
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0501-00-EXIT.
           EXIT.

       0502-00-READ-VS001.

           READ VS001.

           EVALUATE WS-FS-VS001
             WHEN '00'
             WHEN WS-EOF
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0502-00-READ-VS001'
                                    ' FILE STATUS: ' WS-FS-VS001
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0502-00-EXIT.
           EXIT.

       0503-00-CLOSE-VS001.

           CLOSE VS001.

           EVALUATE WS-FS-VS001
             WHEN '00'
               CONTINUE
             WHEN OTHER
               DISPLAY ' ERROR FOUND IN 0503-00-CLOSE-VS001'
                                    ' FILE STATUS: ' WS-FS-VS001
               MOVE 12             TO RETURN-CODE
               STOP RUN
           END-EVALUATE.

       0503-00-EXIT.
           EXIT.