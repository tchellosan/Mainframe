      ******************************************************************
      * DCLGEN TABLE(EAD625.DEPT)                                      *
      *        LIBRARY(GR.EAD625.BOOKLIB(EADD0001))                    *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        STRUCTURE(EADD0001)                                     *
      *        QUOTE                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE EAD625.DEPT TABLE
           ( ID_DEPT                        CHAR(3) NOT NULL,
             NAME                           VARCHAR(30) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE EAD625.DEPT                        *
      ******************************************************************
       01  EADD0001.
           10 ID-DEPT              PIC X(3).
           10 NAME.
              49 NAME-LEN          PIC S9(4) USAGE COMP.
              49 NAME-TEXT         PIC X(30).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 2       *
      ******************************************************************