      ******************************************************************
      * DCLGEN TABLE(EAD625.EMPLOYEE)                                  *
      *        LIBRARY(GR.EAD625.BOOKLIB(EADD0002))                    *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        STRUCTURE(EADD0002)                                     *
      *        QUOTE                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE EAD625.EMPLOYEE TABLE
           ( ID_EMPLOYEE                    CHAR(4) NOT NULL,
             NAME                           VARCHAR(30) NOT NULL,
             SALARY                         DECIMAL(8, 2) NOT NULL,
             ID_DEPT                        CHAR(3) NOT NULL,
             ADMISSION                      DATE NOT NULL,
             AGE                            SMALLINT NOT NULL,
             EMAIL                          VARCHAR(30)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE EAD625.EMPLOYEE                    *
      ******************************************************************
       01  EADD0002.
           10 ID-EMPLOYEE          PIC X(4).
           10 NAME.
              49 NAME-LEN          PIC S9(4) USAGE COMP.
              49 NAME-TEXT         PIC X(30).
           10 SALARY               PIC S9(6)V9(2) USAGE COMP-3.
           10 ID-DEPT              PIC X(3).
           10 ADMISSION            PIC X(10).
           10 AGE                  PIC S9(4) USAGE COMP.
           10 EMAIL.
              49 EMAIL-LEN         PIC S9(4) USAGE COMP.
              49 EMAIL-TEXT        PIC X(30).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 7       *
      ******************************************************************