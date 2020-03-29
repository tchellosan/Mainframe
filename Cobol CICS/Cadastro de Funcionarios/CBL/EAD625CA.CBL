      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD625CA.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMADOR   : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAMA      : EAD625CA                                     *
      *   LINGUAGEM     : COBOL/CICS                                   *
      *   OBJETIVO      : ALTERAR FUNCIONARIO                          *
      *                                                                *
      *================================================================*
       ENVIRONMENT                 DIVISION.
      *================================================================*
       CONFIGURATION               SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      *----------------------------------------------------------------*
       INPUT-OUTPUT                SECTION.

       FILE-CONTROL.

      *================================================================*
       DATA                        DIVISION.
      *================================================================*
       FILE                        SECTION.

      *----------------------------------------------------------------*
       WORKING-STORAGE             SECTION.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'INICIO DA WORKING-STORAGE SECTION'.
      *----------------------------------------------------------------*

       77  WRK-PROGRAMA            PIC X(8)            VALUE 'EAD625CA'.

       77  WRK-RESP-CICS           PIC S9(4)  COMP     VALUE ZEROS.

       77  WRK-ABSTIME             PIC S9(15) COMP-3   VALUE ZEROS.

       77  WRK-PARAGRAFO           PIC X(30)           VALUE SPACES.

       77  WRK-MENSAGEM            PIC X(79)           VALUE SPACES.

       77  WRK-CODIGO-RETORNO      PIC ZZ9             VALUE ZEROS.

       01  WRK-SEND-TEXT           PIC X(1)            VALUE SPACES.
           88  WRK-SEND-TEXT-S                         VALUE 'S'.

       01  WRK-MAPA-DESENHADO      PIC X(1)            VALUE SPACES.
           88  WRK-MAPA-DESENHADO-S                    VALUE 'S'.
           88  WRK-MAPA-DESENHADO-N                    VALUE 'N'.

       77  WRK-NULL-EMAIL          PIC S9(4)  COMP     VALUE ZEROS.
       77  WRK-EXISTE-CAMPO-ALTERADO
                                   PIC S9(4)  COMP     VALUE ZEROS.

       77  WRK-FMT-SQLCODE         PIC -9(3)           VALUE ZEROS.

       01  WRK-CAMPO-INVALIDO      PIC X(1)            VALUE SPACES.
           88  WRK-DEPARTAMENTO-INVALIDO               VALUE '1'.
           88  WRK-DATA-ADMIN-INVALIDA                 VALUE '2'.

       01  WRK-TRANSACAO-DB2       PIC X(1)            VALUE SPACES.
           88  WRK-ROLLBACK-DB2                        VALUE 'S'.

       01  WRK-SALARIO             PIC S9(6)V9(2)      VALUE ZEROS.
       01  FILLER                  REDEFINES WRK-SALARIO.
           05  WRK-SALINT          PIC 9(6).
           05  WRK-SALDEC          PIC 9(2).

       01  WRK-DATA                PIC X(10)           VALUE SPACES.
       01  FILLER                  REDEFINES WRK-DATA.
           05  WRK-ANO             PIC X(4).
           05  FILLER              PIC X(1).
           05  WRK-MES             PIC X(2).
           05  FILLER              PIC X(1).
           05  WRK-DIA             PIC X(2).

       77  WRK-QTDE-CARACTERES     PIC S9(2)  COMP-3   VALUE ZEROS.
       77  WRK-TEXTO               PIC X(30)           VALUE SPACES.

       77  WRK-POS-MSGALTEO        PIC S9(2)  COMP-3   VALUE ZEROS.

       77  WRK-FASE-01             PIC X(1)            VALUE '1'.
       77  WRK-FASE-02             PIC X(1)            VALUE '2'.

       77  ASKNORMON               PIC X(1)            VALUE '1'.
       77  ASKNORMOFF              PIC X(1)            VALUE '0'.
       77  UNPROTBRTOFF            PIC X(1)            VALUE 'H'.
       77  UNPROTBRTON             PIC X(1)            VALUE 'I'.
       77  UNPROTNUMBRTOFF         PIC X(1)            VALUE 'Q'.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MAP00CA'.
      *----------------------------------------------------------------*

           COPY MAP00CA.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MACROS DFH'.
      *----------------------------------------------------------------*

           COPY DFHAID.

           COPY DFHBMSCA.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MODULO EAD625CM'.
      *----------------------------------------------------------------*

       77  WRK-MODULO              PIC X(8)            VALUE 'EAD625CM'.

       01  WRK-COMMAREA.
           05  WRK-ID-FUNC         PIC X(4)            VALUE SPACES.
           05  WRK-MSG             PIC X(79)           VALUE SPACES.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM DB2'.
      *----------------------------------------------------------------*

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
               INCLUDE EADD0002
           END-EXEC.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'FINAL DA WORKING-STORAGE SECTION'.
      *----------------------------------------------------------------*

      *----------------------------------------------------------------*
       LINKAGE                     SECTION.

       01  DFHCOMMAREA.
           05  LKG-ID-FUNC         PIC X(4).
           05  LKG-MSG             PIC X(79).

      *================================================================*
       PROCEDURE                   DIVISION USING DFHCOMMAREA.
      *================================================================*

      *----------------------------------------------------------------*
       0000-PRINCIPAL              SECTION.
      *----------------------------------------------------------------*

       0010-PRINCIPAL.

           PERFORM 1010-INICIALIZAR

           PERFORM 2010-PROCESSAR

           PERFORM 3010-FINALIZAR
           .

       0010-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       1000-INICIALIZAR            SECTION.
      *----------------------------------------------------------------*

       1010-INICIALIZAR.

           MOVE LOW-VALUES         TO MAPALTEI

           IF  EIBCALEN            GREATER ZEROS
               MOVE LKG-ID-FUNC    TO IDFUNCI
               MOVE WRK-FASE-01    TO FASEI
           ELSE
               PERFORM 4010-RECEIVE-MAP
           END-IF
           .

       1010-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       2000-PROCESSAR              SECTION.
      *----------------------------------------------------------------*

       2010-PROCESSAR.

           EVALUATE EIBAID ALSO FASEI
             WHEN DFHPF3   ALSO ANY
               MOVE IDFUNCI        TO WRK-ID-FUNC
               PERFORM 4050-ACIONAR-MODULO

             WHEN DFHPF12  ALSO ANY
               MOVE 'PROGRAMA FINALIZADO. PRESSIONE <ESC>'
                                   TO MSGO
               PERFORM 4060-SEND-TEXT

             WHEN DFHENTER ALSO WRK-FASE-01
               INITIALIZE EADD0002
               MOVE IDFUNCI        TO ID-EMPLOYEE OF EADD0002
               PERFORM 5010-CONSULTAR-FUNCIONARIO
               PERFORM 5030-MOVER-SAIDA
               PERFORM 5050-PREPARAR-FASE-02
               MOVE -1             TO NOMEL
             WHEN DFHENTER ALSO WRK-FASE-02
               PERFORM 5020-ALTERAR-FUNCIONARIO
               IF  NOT WRK-DEPARTAMENTO-INVALIDO AND
                   NOT WRK-DATA-ADMIN-INVALIDA   AND
                       WRK-EXISTE-CAMPO-ALTERADO
                                   GREATER ZEROS
                   PERFORM 5040-PREPARAR-FASE-01
               ELSE
                   MOVE SPACES     TO MSGALTEO
               END-IF

             WHEN OTHER
               CONTINUE

           END-EVALUATE

           PERFORM 4020-SEND-MAP
           .

       2010-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       3000-FINALIZAR              SECTION.
      *----------------------------------------------------------------*

       3010-FINALIZAR.

           EVALUATE TRUE
             WHEN WRK-SEND-TEXT-S
               EXEC CICS
                   RETURN
               END-EXEC
             WHEN OTHER
               EXEC CICS
                   RETURN
                   TRANSID('A25A')
               END-EXEC
           END-EVALUATE
           .

       3010-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       4000-EXEC-CICS              SECTION.
      *----------------------------------------------------------------*

       4010-RECEIVE-MAP.

           MOVE '4010-RECEIVE-MAP' TO WRK-PARAGRAFO

           EXEC CICS RECEIVE
               MAP    ('MAPALTE')
               MAPSET ('MAP00CA')
               INTO   (MAPALTEI)
               RESP   (WRK-RESP-CICS)
           END-EXEC

           EVALUATE WRK-RESP-CICS
             WHEN DFHRESP(NORMAL)
               SET WRK-MAPA-DESENHADO-S
                                   TO TRUE
             WHEN DFHRESP(MAPFAIL)
               SET WRK-MAPA-DESENHADO-N
                                   TO TRUE
               MOVE 'FAVOR INICIAR PELO MENU'
                                   TO MSGO
               PERFORM 4060-SEND-TEXT
             WHEN OTHER
               MOVE WRK-RESP-CICS  TO WRK-CODIGO-RETORNO
               PERFORM 9010-ERRO-CICS
           END-EVALUATE
           .

       4010-EXIT.
           EXIT.

       4020-SEND-MAP.

           MOVE '4020-SEND-MAP'    TO WRK-PARAGRAFO

           PERFORM 4030-FORMATTIME

           IF  EIBCALEN            GREATER ZEROS
               EXEC CICS SEND
                   MAPSET ('MAP00CA')
                   MAP    ('MAPALTE')
                   ERASE
                   CURSOR
                   FROM   (MAPALTEO)
                   RESP(WRK-RESP-CICS)
               END-EXEC
           ELSE
               EXEC CICS SEND
                   MAPSET ('MAP00CA')
                   MAP    ('MAPALTE')
                   DATAONLY
                   CURSOR
                   FROM   (MAPALTEO)
                   RESP(WRK-RESP-CICS)
               END-EXEC
           END-IF

           EVALUATE WRK-RESP-CICS
             WHEN DFHRESP(NORMAL)
               CONTINUE
             WHEN OTHER
               MOVE WRK-RESP-CICS  TO WRK-CODIGO-RETORNO
               PERFORM 9010-ERRO-CICS
           END-EVALUATE
           .

       4020-EXIT.
           EXIT.

       4030-FORMATTIME.

           PERFORM 4040-ASKTIME

           EXEC CICS FORMATTIME
               ABSTIME  (WRK-ABSTIME)
               DDMMYYYY (DATAO)
               DATESEP  ('/')
               TIME     (HORAO)
               TIMESEP  (':')
               RESP     (WRK-RESP-CICS)
           END-EXEC
           .

       4030-EXIT.
           EXIT.

       4040-ASKTIME.

           EXEC CICS ASKTIME
               ABSTIME (WRK-ABSTIME)
           END-EXEC
           .

       4040-EXIT.
           EXIT.

       4050-ACIONAR-MODULO.

           MOVE '4050-ACIONAR-MODULO'
                                   TO WRK-PARAGRAFO

           EXEC CICS XCTL
               PROGRAM  (WRK-MODULO)
               COMMAREA (WRK-COMMAREA)
               RESP     (WRK-RESP-CICS)
           END-EXEC

           EVALUATE WRK-RESP-CICS
             WHEN DFHRESP(PGMIDERR)
               STRING 'PROGRAMA ' WRK-MODULO ' NAO ENCONTRADO'
               DELIMITED BY SIZE INTO MSGO
             WHEN OTHER
               MOVE WRK-RESP-CICS  TO WRK-CODIGO-RETORNO
               PERFORM 9010-ERRO-CICS
           END-EVALUATE
           .

       4050-EXIT.
           EXIT.

       4060-SEND-TEXT.

           MOVE '4060-SEND-TEXT'   TO WRK-PARAGRAFO

           EXEC CICS SEND TEXT
               FROM (MSGO)
               LENGTH(LENGTH OF MSGO)
               ERASE
               FREEKB
           END-EXEC

           SET WRK-SEND-TEXT-S     TO TRUE

           PERFORM 3010-FINALIZAR
           .

       4060-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       5000-EADD0002               SECTION.
      *----------------------------------------------------------------*

       5010-CONSULTAR-FUNCIONARIO.

           MOVE '5010-CONSULTAR-FUNCIONARIO'
                                   TO WRK-PARAGRAFO

           EXEC SQL
               SELECT ID_EMPLOYEE
                    , NAME
                    , SALARY
                    , ID_DEPT
                    , ADMISSION
                    , AGE
                    , EMAIL
                 INTO :EADD0002.ID-EMPLOYEE
                    , :EADD0002.NAME
                    , :EADD0002.SALARY
                    , :EADD0002.ID-DEPT
                    , :EADD0002.ADMISSION
                    , :EADD0002.AGE
                    , :EADD0002.EMAIL INDICATOR :WRK-NULL-EMAIL
                 FROM EAD625.EMPLOYEE
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
                 WITH UR
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN +100
               MOVE IDFUNCI        TO WRK-ID-FUNC
               MOVE 'FUNCIONARIO NAO ENCONTRADO'
                                   TO WRK-MSG
               PERFORM 4050-ACIONAR-MODULO
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE
           .

       5010-EXIT.
           EXIT.

       5020-ALTERAR-FUNCIONARIO.

           PERFORM 5080-EXISTE-CAMPO-ALTERADO

           IF  WRK-EXISTE-CAMPO-ALTERADO
                                   NOT GREATER ZEROS
               MOVE -1             TO NOMEL
           END-IF

           IF  WRK-EXISTE-CAMPO-ALTERADO
                                   NOT GREATER ZEROS
               NEXT SENTENCE
           END-IF

           SET WRK-ROLLBACK-DB2    TO TRUE
           MOVE SPACES             TO MSGO

           MOVE IDFUNCI            TO ID-EMPLOYEE OF EADD0002

           MOVE 'ALTERADOS: '      TO MSGALTEO
           MOVE 11                 TO WRK-POS-MSGALTEO

           IF  NOMEL               GREATER ZEROS
               PERFORM 5021-ATUALIZAR-NOME
           END-IF

           IF  SALINTL             GREATER ZEROS OR
               SALDECL             GREATER ZEROS
               PERFORM 5022-ATUALIZAR-SALARIO
           END-IF

           IF  DEPTOL              GREATER ZEROS
               PERFORM 5023-ATUALIZAR-DEPARTAMENTO
               IF  WRK-DEPARTAMENTO-INVALIDO
                   NEXT SENTENCE
               END-IF
           END-IF

           IF  DIAADML             GREATER ZEROS OR
               MESADML             GREATER ZEROS OR
               ANOADML             GREATER ZEROS
               PERFORM 5024-ATUALIZAR-ADMISSAO
               IF  WRK-DATA-ADMIN-INVALIDA
                   NEXT SENTENCE
               END-IF
           END-IF

           IF  IDADEL              GREATER ZEROS
               PERFORM 5025-ATUALIZAR-IDADE
           END-IF

           IF  EMAILL              GREATER ZEROS
               PERFORM 5026-ATUALIZAR-EMAIL
           END-IF

           PERFORM 5060-COMMIT

           MOVE 'DIGITE UM NOVO CODIGO E <ENTER>'
                                   TO MSGO
           MOVE -1                 TO IDFUNCL
           .

       5020-EXIT.
           EXIT.

       5021-ATUALIZAR-NOME.

           MOVE '5021-ATUALIZAR-NOME'
                                   TO WRK-PARAGRAFO

           MOVE NOMEL              TO NAME-LEN
           MOVE NOMEI              TO NAME-TEXT OF EADD0002

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET NAME = :EADD0002.NAME
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE

           IF  WRK-POS-MSGALTEO    EQUAL 11
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  'NOME'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 4               TO WRK-POS-MSGALTEO
           ELSE
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  ', NOME'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 6               TO WRK-POS-MSGALTEO
           END-IF
           .

       5021-EXIT.
           EXIT.

       5022-ATUALIZAR-SALARIO.

           MOVE '5022-ATUALIZAR-SALARIO'
                                   TO WRK-PARAGRAFO

           INITIALIZE EADD0002
           MOVE IDFUNCI            TO ID-EMPLOYEE OF EADD0002
           PERFORM 5010-CONSULTAR-FUNCIONARIO

           MOVE SALARY OF EADD0002 TO WRK-SALARIO

           IF  SALINTL             GREATER ZEROS
               MOVE SALINTI        TO WRK-SALINT
           END-IF

           IF  SALDECL             GREATER ZEROS
               MOVE SALDECI        TO WRK-SALDEC
           END-IF

           MOVE WRK-SALARIO        TO SALARY OF EADD0002

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET SALARY = :EADD0002.SALARY
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE

           IF  WRK-POS-MSGALTEO    EQUAL 11
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  'SALARIO'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 7               TO WRK-POS-MSGALTEO
           ELSE
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  ', SALARIO'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 9               TO WRK-POS-MSGALTEO
           END-IF
           .

       5022-EXIT.
           EXIT.

       5023-ATUALIZAR-DEPARTAMENTO.

           MOVE '5023-ATUALIZAR-DEPARTAMENTO'
                                   TO WRK-PARAGRAFO

           MOVE DEPTOI             TO ID-DEPT OF EADD0002

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET ID_DEPT = :EADD0002.ID-DEPT
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN -530
               MOVE 'DEPARTAMENTO INFORMADO NAO EXISTE'
                                   TO MSGO
               SET WRK-DEPARTAMENTO-INVALIDO
                                   TO TRUE
               MOVE -1             TO DEPTOL
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE

           IF  WRK-DEPARTAMENTO-INVALIDO
               NEXT SENTENCE
           END-IF

           IF  WRK-POS-MSGALTEO    EQUAL 11
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  'DEPARTAMENTO'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 12              TO WRK-POS-MSGALTEO
           ELSE
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  ', DEPARTAMENTO'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 14              TO WRK-POS-MSGALTEO
           END-IF
           .

       5023-EXIT.
           EXIT.

       5024-ATUALIZAR-ADMISSAO.

           MOVE '5024-ATUALIZAR-ADMISSAO'
                                   TO WRK-PARAGRAFO

           INITIALIZE EADD0002
           MOVE IDFUNCI            TO ID-EMPLOYEE OF EADD0002
           PERFORM 5010-CONSULTAR-FUNCIONARIO

           MOVE ADMISSION OF EADD0002
                                   TO WRK-DATA

           IF  DIAADML             GREATER ZEROS
               MOVE DIAADMI        TO WRK-DIA
           END-IF

           IF  MESADML             GREATER ZEROS
               MOVE MESADMI        TO WRK-MES
           END-IF

           IF  ANOADML             GREATER ZEROS
               MOVE ANOADMI        TO WRK-ANO
           END-IF

           MOVE WRK-DATA           TO ADMISSION OF EADD0002

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET ADMISSION = :EADD0002.ADMISSION
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN -181
               MOVE 'DATA DE ADMISSAO INVALIDA'
                                   TO MSGO
               SET WRK-DATA-ADMIN-INVALIDA
                                   TO TRUE
               MOVE -1             TO DIAADML
             WHEN -180
               MOVE 'DATA DEVE SER INFORMADA'
                                   TO MSGO
               SET WRK-DATA-ADMIN-INVALIDA
                                   TO TRUE
               MOVE -1             TO DIAADML
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE

           IF  WRK-DATA-ADMIN-INVALIDA
               NEXT SENTENCE
           END-IF

           IF  WRK-POS-MSGALTEO    EQUAL 11
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  'ADMISSAO'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 8               TO WRK-POS-MSGALTEO
           ELSE
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  ', ADMISSAO'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 10              TO WRK-POS-MSGALTEO
           END-IF
           .

       5024-EXIT.
           EXIT.

       5025-ATUALIZAR-IDADE.

           MOVE '5025-ATUALIZAR-IDADE'
                                   TO WRK-PARAGRAFO

           MOVE IDADEI             TO AGE OF EADD0002

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET AGE = :EADD0002.AGE
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE


           IF  WRK-POS-MSGALTEO    EQUAL 11
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  'IDADE'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 5               TO WRK-POS-MSGALTEO
           ELSE
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  ', IDADE'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 7               TO WRK-POS-MSGALTEO
           END-IF
           .

       5025-EXIT.
           EXIT.

       5026-ATUALIZAR-EMAIL.

           MOVE '5026-ATUALIZAR-EMAIL'
                                   TO WRK-PARAGRAFO

           MOVE EMAILL             TO EMAIL-LEN
           MOVE EMAILI             TO EMAIL-TEXT OF EADD0002

           IF  EMAIL-LEN           GREATER ZEROS
               MOVE ZEROS          TO WRK-NULL-EMAIL
           ELSE
               MOVE -1             TO WRK-NULL-EMAIL
           END-IF

           EXEC SQL
               UPDATE EAD625.EMPLOYEE
                  SET EMAIL = :EADD0002.EMAIL INDICATOR :WRK-NULL-EMAIL
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               CONTINUE
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE


           IF  WRK-POS-MSGALTEO    EQUAL 11
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  'EMAIL'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 5               TO WRK-POS-MSGALTEO
           ELSE
               STRING MSGALTEO(1:WRK-POS-MSGALTEO)
                  ', EMAIL'
               DELIMITED BY SIZE INTO MSGALTEO
               ADD 7               TO WRK-POS-MSGALTEO
           END-IF
           .

       5026-EXIT.
           EXIT.

       5030-MOVER-SAIDA.

           MOVE ID-EMPLOYEE OF EADD0002
                                   TO IDFUNCO
           MOVE NAME-TEXT OF EADD0002
                                   TO NOMEO
           MOVE SALARY OF EADD0002 TO WRK-SALARIO
           MOVE WRK-SALINT         TO SALINTO
           MOVE WRK-SALDEC         TO SALDECO
           MOVE ID-DEPT OF EADD0002
                                   TO DEPTOO
           MOVE ADMISSION OF EADD0002
                                   TO WRK-DATA
           MOVE WRK-DIA            TO DIAADMO
           MOVE WRK-MES            TO MESADMO
           MOVE WRK-ANO            TO ANOADMO
           MOVE AGE OF EADD0002    TO IDADEO

           IF  WRK-NULL-EMAIL      EQUAL -1
               MOVE SPACES         TO EMAIL-TEXT OF EADD0002
           END-IF
           MOVE EMAIL-TEXT OF EADD0002
                                   TO EMAILO
           MOVE 'ALTERE OS CAMPOS E <ENTER>'
                                   TO MSGO
           .

       5030-EXIT.
           EXIT.

       5040-PREPARAR-FASE-01.

           MOVE WRK-FASE-01        TO FASEO

           MOVE UNPROTBRTON        TO IDFUNCA

           MOVE ASKNORMOFF         TO NOMEA
                                      DEPTOA
                                      EMAILA
                                      SALINTA
                                      SALDECA
                                      DIAADMA
                                      MESADMA
                                      ANOADMA
                                      IDADEA

           .

       5040-EXIT.
           EXIT.

       5050-PREPARAR-FASE-02.

           MOVE WRK-FASE-02        TO FASEO

           MOVE ASKNORMON          TO IDFUNCA

           MOVE UNPROTBRTOFF       TO NOMEA
                                      DEPTOA
                                      EMAILA

           MOVE UNPROTNUMBRTOFF    TO SALINTA
                                      SALDECA
                                      DIAADMA
                                      MESADMA
                                      ANOADMA
                                      IDADEA
           .

       5050-EXIT.
           EXIT.

       5060-COMMIT.

           EXEC CICS
               SYNCPOINT
           END-EXEC
           .

       5060-EXIT.
           EXIT.

       5070-ROLLBACK.

           EXEC CICS
               SYNCPOINT ROLLBACK
           END-EXEC
           .

       5070-EXIT.
           EXIT.

       5080-EXISTE-CAMPO-ALTERADO.

           ADD NOMEL
               SALINTL
               SALDECL
               DEPTOL
               DIAADML
               MESADML
               ANOADML
               IDADEL
               EMAILL              TO WRK-EXISTE-CAMPO-ALTERADO
           .

       5080-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       9000-TRATAMENTO-ERROS       SECTION.
      *----------------------------------------------------------------*

       9010-ERRO-CICS.

           STRING 'ERRO DE ACESSO AO CICS. '
                  'EIBRESP: (' WRK-CODIGO-RETORNO ') '
                  WRK-PARAGRAFO
           DELIMITED BY SIZE INTO WRK-MENSAGEM

           MOVE WRK-MENSAGEM       TO MSGO

           PERFORM 4060-SEND-TEXT
           .

       9010-EXIT.
           EXIT.

       9020-ERRO-DB2.

           STRING 'ERRO DE ACESSO AO DB2. '
                  'SQLCODE: (' WRK-FMT-SQLCODE ') '
                  WRK-PARAGRAFO
           DELIMITED BY SIZE INTO WRK-MENSAGEM

           MOVE WRK-MENSAGEM       TO MSGO

           IF  WRK-ROLLBACK-DB2
               PERFORM 5070-ROLLBACK
           END-IF

           PERFORM 4060-SEND-TEXT
           .

       9020-EXIT.
           EXIT.