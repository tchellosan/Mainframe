//EAD62510  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************
//* DELETE FILE CLIENTSO                                               *
//**********************************************************************
//STEP1    EXEC PGM=IEFBR14
//CLIENTSO DD DSN=GR.EAD625.ARC.CLIENTSO,DISP=(MOD,DELETE,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//**********************************************************************
//* DELETE RELEASES FILE                                               *
//**********************************************************************
//STEP2    EXEC PGM=IEFBR14
//RELEASES DD DSN=GR.EAD625.ARC.RELEASES,DISP=(MOD,DELETE,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//**********************************************************************
//* DELETE FILE CLIENTSN                                               *
//**********************************************************************
//STEP3    EXEC PGM=IEFBR14
//CLIENTSN DD  DSN=GR.EAD625.ARC.CLIENTSN,DISP=(MOD,DELETE,DELETE),
//             SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//**********************************************************************
//* CREATE FILE CLIENTSO                                               *
//**********************************************************************
//STEP4    EXEC PGM=ICEGENER
//SYSUT1   DD *
AA0122222JOSE BONIFACIO      00100000
BB0112345PEDRO ALVARES       00200000
BB0233333MARIA DO BAIRRO     00080000
//SYSUT2   DD DSN=GR.EAD625.ARC.CLIENTSO,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA,
//         DCB=(LRECL=37,RECFM=FB,BLKSIZE=0)
//SYSPRINT DD SYSOUT=*
//**********************************************************************
//* CREATE FILE RELEASES                                               *
//**********************************************************************
//STEP5    EXEC PGM=ICEGENER
//SYSUT1   DD *
BB01123450001C00050000
BB01123450002D00110000
BB01123450003D00200000
BB01223450004C00500000
//SYSUT2   DD DSN=GR.EAD625.ARC.RELEASES,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA,
//         DCB=(LRECL=22,RECFM=FB,BLKSIZE=0)
//SYSPRINT DD SYSOUT=*
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62510                                           *00011003
//**********************************************************************00012003
//STEP6    EXEC PGM=EAD62510
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//CLIENTSO DD DSN=*.STEP4.SYSUT2,DISP=OLD
//RELEASES DD DSN=*.STEP5.SYSUT2,DISP=OLD
//CLIENTSN DD DSN=GR.EAD625.ARC.CLIENTSN,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA,
//         DCB=(LRECL=37,RECFM=FB,BLKSIZE=0)
//SYSOUT   DD SYSOUT=*