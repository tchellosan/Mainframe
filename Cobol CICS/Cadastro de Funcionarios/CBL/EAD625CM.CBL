      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD625CM.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMADOR   : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAMA      : EAD625CM                                     *
      *   LINGUAGEM     : COBOL/CICS                                   *
      *   OBJETIVO      : MENU DE FUNCIONARIOS                         *
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

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'INICIO DA WORKING-STORAGE SECTION'.
      *----------------------------------------------------------------*

       77  WRK-PROGRAMA            PIC X(8)            VALUE 'EAD625CM'.

       77  WRK-RESP-CICS           PIC S9(4)  COMP     VALUE ZEROS.

       77  WRK-ABSTIME             PIC S9(15) COMP-3   VALUE ZEROS.

       77  WRK-PARAGRAFO           PIC X(30)           VALUE SPACES.

       77  WRK-MENSAGEM            PIC X(79)           VALUE SPACES.

       77  WRK-CODIGO-RETORNO      PIC ZZ9             VALUE ZEROS.

       01  WRK-MAPA-DESENHADO      PIC X(1)            VALUE SPACES.
           88  WRK-MAPA-DESENHADO-S                    VALUE 'S'.
           88  WRK-MAPA-DESENHADO-N                    VALUE 'N'.

       01  WRK-OPCAO-MENU          PIC S9(4)  COMP     VALUE ZEROS.
           88  WRK-CONSULTAR                           VALUE 655.
           88  WRK-INCLUIR                             VALUE 815.
           88  WRK-EXCLUIR                             VALUE 975.
           88  WRK-ALTERAR                             VALUE 1135.
           88  WRK-LISTAR                              VALUE 1295.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MAP00CM'.
      *----------------------------------------------------------------*

           COPY MAP00CM.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MACROS DFH'.
      *----------------------------------------------------------------*

           COPY DFHAID.

      *----------------------------------------------------------------*
       77  FILLER                  PIC X(80)           VALUE
           'AREA DE COMUNICACAO COM MODULOS'.
      *----------------------------------------------------------------*

       01  WRK-MODULO              PIC X(8)            VALUE SPACES.
           88  WRK-EAD625CC                            VALUE 'EAD625CC'.
           88  WRK-EAD625CI                            VALUE 'EAD625CI'.
           88  WRK-EAD625CE                            VALUE 'EAD625CE'.
           88  WRK-EAD625CA                            VALUE 'EAD625CA'.
           88  WRK-EAD625CL                            VALUE 'EAD625CL'.

       01  WRK-COMMAREA.
           05  WRK-ID-FUNC         PIC X(4)            VALUE SPACES.

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

           MOVE LOW-VALUES         TO MAPMENUI

           IF  EIBCALEN            GREATER ZEROS
               PERFORM 1020-LER-COMMAREA
               MOVE 0              TO EIBCPOSN
           ELSE
               PERFORM 4010-RECEIVE-MAP
               IF  EIBAID          EQUAL DFHENTER
                   PERFORM 1030-VALIDAR-DADOS-ENTRADA
               END-IF
           END-IF
           .

       1010-EXIT.
           EXIT.

       1020-LER-COMMAREA.

           MOVE LKG-ID-FUNC        TO IDFUNCI

           IF  LKG-MSG             NOT EQUAL SPACES
               MOVE LKG-MSG        TO MSGO
           END-IF
           .

       1020-EXIT.
           EXIT.

       1030-VALIDAR-DADOS-ENTRADA.

           INSPECT IDFUNCI REPLACING ALL LOW-VALUES BY SPACES

           IF  IDFUNCI             EQUAL SPACES
               STRING 'INFORME O CODIGO DO FUNCIONARIO, '
                      'ESCOLHA UMA FUNCAO E <ENTER>'
               DELIMITED BY SIZE INTO MSGO
               PERFORM 4020-SEND-MAP
               PERFORM 3010-FINALIZAR
           ELSE
               STRING 'ESCOLHA UMA FUNCAO E <ENTER>'
               DELIMITED BY SIZE INTO MSGO
           END-IF
           .

       1030-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       2000-PROCESSAR              SECTION.
      *----------------------------------------------------------------*

       2010-PROCESSAR.

           IF  EIBAID              EQUAL DFHPF12
               MOVE 'PROGRAMA FINALIZADO. PRESSIONE <ESC>'
                                   TO MSGO
               PERFORM 4060-SEND-TEXT
           END-IF

           IF  EIBAID              EQUAL DFHENTER
               CONTINUE
           ELSE
               NEXT SENTENCE
           END-IF

           MOVE EIBCPOSN           TO WRK-OPCAO-MENU

           EVALUATE TRUE
             WHEN WRK-CONSULTAR
               SET WRK-EAD625CC    TO TRUE
             WHEN WRK-INCLUIR
               SET WRK-EAD625CI    TO TRUE
             WHEN WRK-EXCLUIR
               SET WRK-EAD625CE    TO TRUE
             WHEN WRK-ALTERAR
               SET WRK-EAD625CA    TO TRUE
             WHEN WRK-LISTAR
               SET WRK-EAD625CL    TO TRUE
           END-EVALUATE

           IF  WRK-MODULO          NOT EQUAL SPACES
               PERFORM 4050-ACIONAR-MODULO
           END-IF
           .

           PERFORM 4020-SEND-MAP
           .

       2010-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       3000-FINALIZAR              SECTION.
      *----------------------------------------------------------------*

       3010-FINALIZAR.

           EXEC CICS
               RETURN
           END-EXEC
           .

       3010-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       4000-EXEC-CICS              SECTION.
      *----------------------------------------------------------------*

       4010-RECEIVE-MAP.

           MOVE '4010-RECEIVE-MAP' TO WRK-PARAGRAFO

           EXEC CICS RECEIVE
               MAP    ('MAPMENU')
               MAPSET ('MAP00CM')
               INTO   (MAPMENUI)
               RESP   (WRK-RESP-CICS)
           END-EXEC

           EVALUATE WRK-RESP-CICS
             WHEN DFHRESP(NORMAL)
               SET WRK-MAPA-DESENHADO-S
                                   TO TRUE
               MOVE 'ESCOLHA UMA FUNCAO E <ENTER>'
                                   TO MSGO
             WHEN DFHRESP(MAPFAIL)
      *        SET WRK-MAPA-DESENHADO-N
      *                            TO TRUE
               PERFORM 4020-SEND-MAP
               PERFORM 3010-FINALIZAR
             WHEN OTHER
               MOVE WRK-RESP-CICS  TO WRK-CODIGO-RETORNO
               PERFORM 9010-ERRO-CICS
           END-EVALUATE
           .

       4010-EXIT.
           EXIT.

       4020-SEND-MAP.

           MOVE '4020-SEND-MAP'    TO WRK-PARAGRAFO

           MOVE 'A25M'             TO CODTRANO

           PERFORM 4030-FORMATTIME

           EVALUATE TRUE
             WHEN WRK-MAPA-DESENHADO-S
               EXEC CICS SEND
                   MAPSET ('MAP00CM')
                   MAP    ('MAPMENU')
                   FROM   (MAPMENUO)
                   DATAONLY
                   RESP(WRK-RESP-CICS)
               END-EXEC
      *      WHEN WRK-MAPA-DESENHADO-N
      *        EXEC CICS SEND
      *            MAPSET ('MAP00CM')
      *            MAP    ('MAPMENU')
      *            ERASE
      *            RESP(WRK-RESP-CICS)
      *        END-EXEC
             WHEN OTHER
               EXEC CICS SEND
                   MAPSET ('MAP00CM')
                   MAP    ('MAPMENU')
                   ERASE
                   FROM   (MAPMENUO)
                   RESP(WRK-RESP-CICS)
               END-EXEC
           END-EVALUATE

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
               RESP    (WRK-RESP-CICS)
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

           MOVE IDFUNCI            TO WRK-ID-FUNC

           EXEC CICS XCTL
               PROGRAM  (WRK-MODULO)
               COMMAREA (WRK-COMMAREA)
               RESP     (WRK-RESP-CICS)
           END-EXEC

           EVALUATE WRK-RESP-CICS
             WHEN DFHRESP(PGMIDERR)
               STRING 'MODULO DE CARGA ' WRK-MODULO ' NAO ENCONTRADO'
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

           PERFORM 3010-FINALIZAR
           .

       4060-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       9000-TRATAMENTO-ERROS       SECTION.
      *----------------------------------------------------------------*

       9010-ERRO-CICS.

           STRING 'ERRO DE ACESSO AO CICS. '
                  'CODIGO: ' WRK-CODIGO-RETORNO ' '
                  WRK-PARAGRAFO
           DELIMITED BY SIZE INTO WRK-MENSAGEM

           MOVE WRK-MENSAGEM       TO MSGO

           PERFORM 4060-SEND-TEXT
           .

       9010-EXIT.
           EXIT.