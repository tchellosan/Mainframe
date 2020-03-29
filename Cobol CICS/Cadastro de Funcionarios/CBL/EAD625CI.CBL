      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD625CI.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMADOR   : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAMA      : EAD625CI                                     *
      *   LINGUAGEM     : COBOL/CICS                                   *
      *   OBJETIVO      : INCLUIR FUNCIONARIO                          *
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

       77  WRK-PROGRAMA            PIC X(8)            VALUE 'EAD625CI'.

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

       77  WRK-FMT-SQLCODE         PIC -9(3)           VALUE ZEROS.

       01  WRK-SALARIO             PIC S9(6)V9(2)      VALUE ZEROS.
       01  FILLER                  REDEFINES WRK-SALARIO.
           05  WRK-SALINT          PIC 9(6).
           05  WRK-SALDEC          PIC 9(2).

       01  WRK-DATA                PIC X(10)         VALUE '0001-01-01'.
       01  FILLER                  REDEFINES WRK-DATA.
           05  WRK-ANO             PIC X(4).
           05  FILLER              PIC X(1).
           05  WRK-MES             PIC X(2).
           05  FILLER              PIC X(1).
           05  WRK-DIA             PIC X(2).

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MAP00CI'.
      *----------------------------------------------------------------*

           COPY MAP00CI.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MACROS DFH'.
      *----------------------------------------------------------------*

           COPY DFHAID.

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

           MOVE LOW-VALUES         TO MAPINCLI

           IF  EIBCALEN            GREATER ZEROS
               MOVE LKG-ID-FUNC    TO IDFUNCI
               PERFORM 5030-CONSULTAR-FUNCIONARIO
               PERFORM 4020-SEND-MAP
               PERFORM 3010-FINALIZAR
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

           EVALUATE EIBAID
             WHEN DFHPF3
               MOVE IDFUNCI        TO WRK-ID-FUNC
               PERFORM 4050-ACIONAR-MODULO
             WHEN DFHPF12
               MOVE 'PROGRAMA FINALIZADO. PRESSIONE <ESC>'
                                   TO MSGO
               PERFORM 4060-SEND-TEXT
             WHEN DFHENTER
               PERFORM 5010-INCLUIR-FUNCIONARIO
             WHEN OTHER
               CONTINUE
           END-EVALUATE

           MOVE LOW-VALUES         TO SALINTO

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
                   TRANSID('A25I')
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
               MAP    ('MAPINCL')
               MAPSET ('MAP00CI')
               INTO   (MAPINCLI)
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
                   MAPSET ('MAP00CI')
                   MAP    ('MAPINCL')
                   ERASE
                   FROM   (MAPINCLO)
                   RESP(WRK-RESP-CICS)
               END-EXEC
           ELSE
               EXEC CICS SEND
                   MAPSET ('MAP00CI')
                   MAP    ('MAPINCL')
                   DATAONLY
                   CURSOR
                   FROM   (MAPINCLO)
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

       5010-INCLUIR-FUNCIONARIO.

           MOVE '5010-INCLUIR-FUNCIONARIO'
                                   TO WRK-PARAGRAFO

           INITIALIZE EADD0002

           MOVE IDFUNCI            TO ID-EMPLOYEE OF EADD0002

           MOVE NOMEL              TO NAME-LEN OF EADD0002
           MOVE NOMEI              TO NAME-TEXT   OF EADD0002

           MOVE SALINTI            TO WRK-SALINT
           MOVE SALDECI            TO WRK-SALDEC
           MOVE WRK-SALARIO        TO SALARY      OF EADD0002

           MOVE DEPTOI             TO ID-DEPT     OF EADD0002

           MOVE DIAADMI            TO WRK-DIA
           MOVE MESADMI            TO WRK-MES
           MOVE ANOADMI            TO WRK-ANO
           MOVE WRK-DATA           TO ADMISSION   OF EADD0002

           MOVE IDADEI             TO AGE         OF EADD0002

           MOVE EMAILL             TO EMAIL-LEN OF EADD0002
           MOVE EMAILI             TO EMAIL-TEXT OF EADD0002

           IF  EMAIL-LEN           GREATER ZEROS
               MOVE ZEROS          TO WRK-NULL-EMAIL
           ELSE
               MOVE -1             TO WRK-NULL-EMAIL
           END-IF

           EXEC SQL
               INSERT INTO EAD625.EMPLOYEE
               VALUES (:EADD0002.ID-EMPLOYEE
                     , :EADD0002.NAME
                     , :EADD0002.SALARY
                     , :EADD0002.ID-DEPT
                     , :EADD0002.ADMISSION
                     , :EADD0002.AGE
                     , :EADD0002.EMAIL INDICATOR :WRK-NULL-EMAIL)
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               MOVE IDFUNCI        TO WRK-ID-FUNC
               MOVE 'INCLUSAO REALIZADA COM SUCESSO'
                                   TO WRK-MSG
               PERFORM 4050-ACIONAR-MODULO
             WHEN -530
               MOVE 'DEPARTAMENTO INFORMADO NAO EXISTE'
                                   TO MSGO
               MOVE -1             TO DEPTOL
             WHEN -181
               MOVE 'DATA DE ADMISSAO INVALIDA'
                                   TO MSGO
               MOVE -1             TO DIAADML
             WHEN -180
               MOVE 'DATA DEVE SER INFORMADA'
                                   TO MSGO
               MOVE -1             TO DIAADML
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE
           .

       5010-EXIT.
           EXIT.

       5030-CONSULTAR-FUNCIONARIO.

           MOVE '5030-CONSULTAR-FUNCIONARIO'
                                   TO WRK-PARAGRAFO

           INITIALIZE EADD0002

           MOVE IDFUNCI            TO ID-EMPLOYEE OF EADD0002

           EXEC SQL
               SELECT ID_EMPLOYEE
                 INTO :EADD0002.ID-EMPLOYEE
                 FROM EAD625.EMPLOYEE
                WHERE ID_EMPLOYEE = :EADD0002.ID-EMPLOYEE
                 WITH UR
           END-EXEC

           EVALUATE SQLCODE
             WHEN ZEROS
               MOVE IDFUNCI        TO WRK-ID-FUNC
               MOVE 'FUNCIONARIO JA CADASTRADO'
                                   TO WRK-MSG
               PERFORM 4050-ACIONAR-MODULO
             WHEN +100
               MOVE '1'            TO IDFUNCA
             WHEN OTHER
               MOVE SQLCODE        TO WRK-FMT-SQLCODE
               PERFORM 9020-ERRO-DB2
           END-EVALUATE
           .

       5030-EXIT.
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

           PERFORM 4060-SEND-TEXT
           .

       9020-EXIT.
           EXIT.