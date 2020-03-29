*-------------------------------------------------------*
*       DFHMSD BEGIN
*-------------------------------------------------------*
MAP00CI DFHMSD TYPE=MAP,                                               *
               MODE=INOUT,                                             *
               LANG=COBOL,                                             *
               CTRL=FREEKB,                                            *
               TIOAPFX=YES

*-------------------------------------------------------*
*       DFHMDI
*-------------------------------------------------------*
MAPINCL DFHMDI SIZE=(24,80)

*-------------------------------------------------------*
*       DFHMDF
*-------------------------------------------------------*

*-------------------------------------------------------*
*       LINHA 1
*-------------------------------------------------------*
CODTRAN DFHMDF POS=(1,1),                                              *
               LENGTH=4,                                               *
               ATTRB=(UNPROT,BRT,FSET),                                *
               INITIAL='A25I'
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
               LENGTH=7,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='INCLUIR'
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
               ATTRB=(UNPROT,BRT,FSET)
        DFHMDF POS=(6,42),                                             *
               LENGTH=0,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 9
*-------------------------------------------------------*
        DFHMDF POS=(9,15),                                             *
               LENGTH=14,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='NOME         :'
NOME    DFHMDF POS=(9,30),                                             *
               LENGTH=30,                                              *
               ATTRB=(UNPROT,BRT,FSET,IC)
        DFHMDF POS=(9,61),                                             *
               LENGTH=0,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 11
*-------------------------------------------------------*
        DFHMDF POS=(11,15),                                            *
               LENGTH=14,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='SALARIO      :'
SALINT  DFHMDF POS=(11,30),                                            *
               LENGTH=6,                                               *
               ATTRB=(UNPROT,NUM,BRT,FSET),                            *
               PICIN='9(6)'
        DFHMDF POS=(11,37),                                            *
               LENGTH=1,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL=','
SALDEC  DFHMDF POS=(11,39),                                            *
               LENGTH=2,                                               *
               ATTRB=(UNPROT,NUM,BRT,FSET),                            *
               PICIN='9(2)'
        DFHMDF POS=(11,42),                                            *
               LENGTH=0,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 13
*-------------------------------------------------------*
        DFHMDF POS=(13,15),                                            *
               LENGTH=14,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='DEPARTAMENTO :'
DEPTO   DFHMDF POS=(13,30),                                            *
               LENGTH=3,                                               *
               ATTRB=(UNPROT,BRT,FSET)
        DFHMDF POS=(13,34),                                            *
               LENGTH=0,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 15
*-------------------------------------------------------*
        DFHMDF POS=(15,15),                                            *
               LENGTH=14,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='ADMISSAO     :'
DIAADM  DFHMDF POS=(15,30),                                            *
               LENGTH=2,                                               *
               ATTRB=(UNPROT,NUM,BRT,FSET),                            *
               PICIN='9(2)'
        DFHMDF POS=(15,33),                                            *
               LENGTH=1,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='/'
MESADM  DFHMDF POS=(15,35),                                            *
               LENGTH=2,                                               *
               ATTRB=(UNPROT,NUM,BRT,FSET),                            *
               PICIN='9(2)'
        DFHMDF POS=(15,38),                                            *
               LENGTH=1,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='/'
ANOADM  DFHMDF POS=(15,40),                                            *
               LENGTH=4,                                               *
               ATTRB=(UNPROT,NUM,BRT,FSET),                            *
               PICIN='9(4)'
        DFHMDF POS=(15,45),                                            *
               LENGTH=0,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 17
*-------------------------------------------------------*
        DFHMDF POS=(17,15),                                            *
               LENGTH=14,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='IDADE        :'
IDADE   DFHMDF POS=(17,30),                                            *
               LENGTH=2,                                               *
               ATTRB=(UNPROT,NUM,BRT,FSET),                            *
               PICIN='9(2)'
        DFHMDF POS=(17,33),                                            *
               LENGTH=0,                                               *
               ATTRB=ASKIP
*-------------------------------------------------------*
*       LINHA 19
*-------------------------------------------------------*
        DFHMDF POS=(19,15),                                            *
               LENGTH=14,                                              *
               ATTRB=ASKIP,                                            *
               INITIAL='EMAIL        :'
EMAIL   DFHMDF POS=(19,30),                                            *
               LENGTH=30,                                              *
               ATTRB=(UNPROT,BRT,FSET)
        DFHMDF POS=(19,61),                                            *
               LENGTH=0,                                               *
               ATTRB=ASKIP
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
               INITIAL='INFORME OS CAMPOS E <ENTER>'
*-------------------------------------------------------*
*       LINHA 23
*-------------------------------------------------------*
        DFHMDF POS=(23,1),                                             *
               LENGTH=7,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='F3-MENU'
        DFHMDF POS=(23,71),                                            *
               LENGTH=8,                                               *
               ATTRB=ASKIP,                                            *
               INITIAL='F12-SAIR'
*-------------------------------------------------------*
*       DFHMSD END
*-------------------------------------------------------*
        DFHMSD TYPE=FINAL
        END