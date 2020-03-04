//EAD62513  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************
//* DELETE SALES3L FILE                                                *
//**********************************************************************
//STEP1    EXEC PGM=IEFBR14
//SALES3L  DD DSN=GR.EAD625.ARC.SALES3L,DISP=(MOD,DELETE,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//**********************************************************************
//* CREATE SALES3L FILE                                                *
//**********************************************************************
//STEP2    EXEC PGM=ICEGENER
//SYSUT1   DD *
01SP0300000100010000
01RJ0400000200020000
02SP0100000300030000
02SP0400000400040000
01MG0200000500050000
02MG0200000600060000
01RJ0300000700070000
01RJ0300000800080000
02SP0100000900090000
01SP0400001000100000
//SYSUT2   DD DSN=GR.EAD625.ARC.SALES3L,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA,
//         DCB=(LRECL=20,RECFM=FB,BLKSIZE=0)
//SYSPRINT DD SYSOUT=*
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62513                                           *00011003
//**********************************************************************00012003
//STEP3    EXEC PGM=EAD62513
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SALES3L DD DSN=*.STEP2.SYSUT2,DISP=OLD
//SYSOUT   DD SYSOUT=*