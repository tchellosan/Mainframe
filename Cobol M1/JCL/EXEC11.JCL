//EAD62511  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************
//* DELETE CLIENTSR FILE                                               *
//**********************************************************************
//STEP1    EXEC PGM=IEFBR14
//CLIENTSR DD DSN=GR.EAD625.ARC.CLIENTSR,DISP=(MOD,DELETE,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//**********************************************************************
//* CREATE CLIENTSR FILE                                               *
//**********************************************************************
//STEP2    EXEC PGM=ICEGENER
//SYSUT1   DD *
AA0111111JOSE 1              00005000
AA0122222JOSE 2              00006000
AA0133333JOSE 3              00007000
AA0144444JOSE 4              00008000
AA0155555JOSE 5              00009000
AA0166666JOSE 6              00010000
BB0177777JOSE 7              00011000
BB0188888JOSE 8              00012000
//SYSUT2   DD DSN=GR.EAD625.ARC.CLIENTSR,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA,
//         DCB=(LRECL=37,RECFM=FB,BLKSIZE=0)
//SYSPRINT DD SYSOUT=*
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62511                                           *00011003
//**********************************************************************00012003
//STEP3    EXEC PGM=EAD62511
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//CLIENTSR DD DSN=*.STEP2.SYSUT2,DISP=OLD
//REPORTC  DD SYSOUT=*
//SYSOUT   DD SYSOUT=*