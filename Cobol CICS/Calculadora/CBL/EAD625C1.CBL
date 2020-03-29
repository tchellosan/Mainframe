      *================================================================*
       IDENTIFICATION              DIVISION.
      *================================================================*
       PROGRAM-ID.                 EAD625C1.
       AUTHOR.                     MARCELO SILVA.
       DATE-WRITTEN.               MAR/2020.
      *----------------------------------------------------------------*
      *                                                                *
      *   PROGRAMADOR   : MARCELO SILVA                                *
      *   EMAIL         : TCHELLOSAN@GMAIL.COM                         *
      *   PROGRAMA      : EAD625C1                                     *
      *   LINGUAGEM     : COBOL/CICS                                   *
      *   OBJETIVO      : CALCULADORA                                  *
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

       77  WRK-PROGRAM             PIC X(8)            VALUE 'EAD625C1'.

       77  WRK-RESP-CICS           PIC S9(4) COMP      VALUE ZEROS.

       77  WRK-RESP-CICS-EDIT      PIC ZZ9             VALUE ZEROS.

       77  WRK-ABSTIME             PIC S9(15) COMP-3   VALUE ZEROS.

       77  WRK-PARAGRAFO           PIC X(30)           VALUE SPACES.
       77  WRK-MENSAGEM            PIC X(35)           VALUE SPACES.
       77  WRK-CODIGO-RETORNO      PIC ZZ9             VALUE ZEROS.

       01  WRK-MAPA-DESENHADO      PIC X(1)            VALUE SPACES.
           88  WRK-MAPA-DESENHADO-S                    VALUE 'S'.
           88  WRK-MAPA-DESENHADO-N                    VALUE 'N'.

           COPY MAP00C1.

      *================================================================*
       PROCEDURE                   DIVISION.
      *================================================================*
      *----------------------------------------------------------------*
       0000-PRINCIPAL              SECTION.
      *----------------------------------------------------------------*

       0100-PRINCIPAL.

           PERFORM 1100-INICIALIZAR.

           PERFORM 2100-PROCESSAR.

           PERFORM 3100-FINALIZAR.

       0100-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       1000-INICIALIZAR            SECTION.
      *----------------------------------------------------------------*

       1100-INICIALIZAR.

           PERFORM 4100-RECEIVE-MAP.

       1100-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       2000-PROCESSAR              SECTION.
      *----------------------------------------------------------------*

       2100-PROCESSAR.

           PERFORM 4300-BIF-DEEDIT-N1I.
           PERFORM 4310-BIF-DEEDIT-N2I.

           EVALUATE OPI
             WHEN '+'
               ADD N1I N2I         GIVING RESULTO
             WHEN '-'
               SUBTRACT N2I FROM N1I
                                   GIVING RESULTO
               MOVE 'SUBTRACAO EFETUADA COM SUCESSO.'
                                   TO MSGO
             WHEN '*'
             WHEN 'X'
               MULTIPLY N1I BY N2I GIVING RESULTO
               MOVE 'MULTIPLICACAO EFETUADA COM SUCESSO.'
                                   TO MSGO
             WHEN '/'
             WHEN ':'
               DIVIDE N1I BY N2I GIVING RESULTO
               MOVE 'DIVISAO EFETUADA COM SUCESSO.'
                                   TO MSGO
             WHEN OTHER
               MOVE 'OPERACAO INVALIDA.'
                                   TO MSGO
           END-EVALUATE.

           MOVE LOW-VALUES         TO N1O
                                      N2O.

           PERFORM 4200-SEND-MAP.

       2100-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       3000-FINALIZAR              SECTION.
      *----------------------------------------------------------------*

       3100-FINALIZAR.

           EXEC CICS
               RETURN
           END-EXEC.

       3100-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       4000-EXEC-CICS              SECTION.
      *----------------------------------------------------------------*

       4100-RECEIVE-MAP.

           MOVE '4100-RECEIVE-MAP'
                                   TO WRK-PARAGRAFO

           EXEC CICS RECEIVE
               MAP    ('MAPCALC')
               MAPSET ('MAP00C1')
               INTO   (MAPCALCI)
               RESP   (WRK-RESP-CICS)
           END-EXEC.

           EVALUATE WRK-RESP-CICS
             WHEN DFHRESP(NORMAL)
               SET WRK-MAPA-DESENHADO-S
                                   TO TRUE
             WHEN DFHRESP(MAPFAIL)
               SET WRK-MAPA-DESENHADO-N
                                   TO TRUE
               PERFORM 4200-SEND-MAP
               PERFORM 3100-FINALIZAR
             WHEN OTHER
               MOVE WRK-RESP-CICS  TO WRK-CODIGO-RETORNO
               PERFORM 9100-ERRO-CICS
           END-EVALUATE.

       4100-EXIT.
           EXIT.

       4200-SEND-MAP.

           MOVE '4200-SEND-MAP' TO WRK-PARAGRAFO

           PERFORM 4400-FORMATTIME.

           EVALUATE TRUE
             WHEN WRK-MAPA-DESENHADO-S
               EXEC CICS SEND
                   MAPSET ('MAP00C1')
                   MAP    ('MAPCALC')
                   FROM   (MAPCALCO)
                   DATAONLY
                   RESP(WRK-RESP-CICS)
               END-EXEC

             WHEN OTHER
               EXEC CICS SEND
                   MAPSET ('MAP00C1')
                   MAP    ('MAPCALC')
                   MAPONLY
                   ERASE
                   RESP(WRK-RESP-CICS)
               END-EXEC

           END-EVALUATE.

           EVALUATE WRK-RESP-CICS
             WHEN DFHRESP(NORMAL)
               CONTINUE
             WHEN OTHER
               MOVE WRK-RESP-CICS  TO WRK-CODIGO-RETORNO
               PERFORM 9100-ERRO-CICS
           END-EVALUATE.

       4200-EXIT.
           EXIT.

       4300-BIF-DEEDIT-N1I.

           EXEC CICS BIF
               DEEDIT FIELD(N1I)
           END-EXEC.

       4300-EXIT.
           EXIT.

       4310-BIF-DEEDIT-N2I.

           EXEC CICS BIF
               DEEDIT FIELD(N2I)
           END-EXEC.

       4310-EXIT.
           EXIT.

       4400-FORMATTIME.

           PERFORM 4420-ASKTIME.

           EXEC CICS FORMATTIME
               ABSTIME  (WRK-ABSTIME)
               DDMMYYYY (DATAO)
               DATESEP  ('/')
               TIME     (HORAO)
               TIMESEP  (':')
               RESP    (WRK-RESP-CICS)
           END-EXEC.

       4400-EXIT.
           EXIT.

       4420-ASKTIME.

           EXEC CICS ASKTIME
               ABSTIME (WRK-ABSTIME)
           END-EXEC.

       4420-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       9000-TRATAMENTO-ERROS       SECTION.
      *----------------------------------------------------------------*

       9100-ERRO-CICS.

           STRING 'ERRO DE ACESSO AO CICS. '
                  'CODIGO: ' WRK-CODIGO-RETORNO ' '
                  WRK-PARAGRAFO
           DELIMITED BY SIZE INTO WRK-MENSAGEM.

           MOVE WRK-MENSAGEM       TO MSGO.

           PERFORM 3100-FINALIZAR.

       9100-EXIT.
           EXIT.