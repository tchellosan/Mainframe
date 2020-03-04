//EAD62512  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************
//* DELETE SALES FILE                                                  *
//**********************************************************************
//STEP1    EXEC PGM=IEFBR14
//SALES    DD DSN=GR.EAD625.ARC.SALES,DISP=(MOD,DELETE,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//**********************************************************************
//* CREATE SALES FILE                                                  *
//**********************************************************************
//STEP2    EXEC PGM=ICEGENER
//SYSUT1   DD *
0000010500010000
0000010200020000
0000011100030000
0000010500040000
0000010900050000
0000010400060000
0000010200070000
0000011200080000
0000010500090000
0000010700100000
0000011500050000
0000011600060000
0000011700070000
//SYSUT2   DD DSN=GR.EAD625.ARC.SALES,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA,
//         DCB=(LRECL=16,RECFM=FB,BLKSIZE=0)
//SYSPRINT DD SYSOUT=*
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62512                                           *00011003
//**********************************************************************00012003
//STEP3    EXEC PGM=EAD62512
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SALES DD DSN=*.STEP2.SYSUT2,DISP=OLD
//SYSOUT   DD SYSOUT=*