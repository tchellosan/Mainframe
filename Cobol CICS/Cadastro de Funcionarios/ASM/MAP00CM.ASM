*-------------------------------------------------------*
*       DFHMSD BEGIN
*-------------------------------------------------------*
MAP00CM DFHMSD TYPE=MAP,                                               *
               MODE=INOUT,                                             *
               LANG=COBOL,                                             *
               CTRL=FREEKB,                                            *
               TIOAPFX=YES

*-------------------------------------------------------*
*       DFHMDI
*-------------------------------------------------------*
MAPMENU DFHMDI SIZE=(24,80)

*-------------------------------------------------------*
*       DFHMDF
*-------------------------------------------------------*

*-------------------------------------------------------*
*       LINHA 1
*-------------------------------------------------------*
CODTRAN DFHMDF POS=(1,1),                                              *
               LENGTH=4,                                               *
               ATTRB=(UNPROT,BRT,FSET),                                *
               INITIAL='A25M'
        DFHMDF POS=(1,6),                                              *
               LENGTH=0,                                               *
               ATTRB=ASKIP
        DFHMDF POS=(1,25),                                             *
               LENGTH=24,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='CADASTRO DE FUNCIONARIOS'
        DFHMDF POS=(1,63),                                             *
               LENGTH=5,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='DATA:'
DATA    DFHMDF POS=(1,69),                                             *
               LENGTH=10,                                              *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 2
*-------------------------------------------------------*
        DFHMDF POS=(2,33),                                             *
               LENGTH=4,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='MENU'
        DFHMDF POS=(2,63),                                             *
               LENGTH=5,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='HORA:'
HORA    DFHMDF POS=(2,69),                                             *
               LENGTH=8,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 3
*-------------------------------------------------------*
        DFHMDF POS=(3,1),                                              *
               LENGTH=78,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='-----------------------------------------------*
               -------------------------------'
*-------------------------------------------------------*
*       LINHA 6
*-------------------------------------------------------*
        DFHMDF POS=(6,15),                                             *
               LENGTH=21,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='CODIGO DO FUNCIONARIO'
IDFUNC  DFHMDF POS=(6,37),                                             *
               LENGTH=4,                                               *
               ATTRB=(UNPROT,BRT,FSET,IC)
        DFHMDF POS=(6,42),                                             *
               LENGTH=0,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 9
*-------------------------------------------------------*
        DFHMDF POS=(9,15),                                             *
               LENGTH=1,                                               *
               ATTRB=(UNPROT,BRT),                                     *
               INITIAL='.'
        DFHMDF POS=(9,17),                                             *
               LENGTH=9,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='CONSULTAR'
*-------------------------------------------------------*
*       LINHA 11
*-------------------------------------------------------*
        DFHMDF POS=(11,15),                                            *
               LENGTH=1,                                               *
               ATTRB=(UNPROT,BRT),                                     *
               INITIAL='.'
        DFHMDF POS=(11,17),                                            *
               LENGTH=7,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='INCLUIR'
*-------------------------------------------------------*
*       LINHA 13
*-------------------------------------------------------*
        DFHMDF POS=(13,15),                                            *
               LENGTH=1,                                               *
               ATTRB=(UNPROT,BRT),                                     *
               INITIAL='.'
        DFHMDF POS=(13,17),                                            *
               LENGTH=7,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='EXCLUIR'
*-------------------------------------------------------*
*       LINHA 15
*-------------------------------------------------------*
        DFHMDF POS=(15,15),                                            *
               LENGTH=1,                                               *
               ATTRB=(UNPROT,BRT),                                     *
               INITIAL='.'
        DFHMDF POS=(15,17),                                            *
               LENGTH=7,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='ALTERAR'
*-------------------------------------------------------*
*       LINHA 17
*-------------------------------------------------------*
        DFHMDF POS=(17,15),                                            *
               LENGTH=1,                                               *
               ATTRB=(UNPROT,BRT),                                     *
               INITIAL='.'
        DFHMDF POS=(17,17),                                            *
               LENGTH=6,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='LISTAR'
*-------------------------------------------------------*
*       LINHA 21
*-------------------------------------------------------*
        DFHMDF POS=(21,1),                                             *
               LENGTH=78,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='-----------------------------------------------*
               -------------------------------'
*-------------------------------------------------------*
*       LINHA 22
*-------------------------------------------------------*
MSG     DFHMDF POS=(22,1),                                             *
               LENGTH=78,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='INFORME O CODIGO DO FUNCIONARIO, ESCOLHA UMA FU*
               NCAO E <ENTER>'
*-------------------------------------------------------*
*       LINHA 23
*-------------------------------------------------------*
        DFHMDF POS=(23,59),                                            *
               LENGTH=20,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='ESC-LIMPAR  F12-SAIR'
*-------------------------------------------------------*
*       DFHMSD END
*-------------------------------------------------------*
        DFHMSD TYPE=FINAL
        END