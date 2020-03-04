//EAD62509  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************
//* DELETE FILE CLIENTS                                                *
//**********************************************************************
//STEP1    EXEC PGM=IEFBR14
//CLIENTS DD DSN=GR.EAD625.ARC.CLIENTS,DISP=(MOD,DELETE,DELETE),
//             SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//**********************************************************************
//* CREATE FILE CLIENTS                                                *
//**********************************************************************
//STEP2    EXEC PGM=ICEGENER
//SYSUT1   DD *
AA0122222JOSE BONIFACIO      00100000
BB0112345PEDRO ALVARES       00200000
BB0233333MARIA DO BAIRRO     00080000
//SYSUT2   DD DSN=GR.EAD625.ARC.CLIENTS,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA,
//         DCB=(LRECL=37,RECFM=FB,BLKSIZE=0)
//SYSPRINT DD SYSOUT=*
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62509                                           *00011003
//**********************************************************************00012003
//STEP3    EXEC PGM=EAD62509
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//CLIENTS  DD DSN=*.STEP2.SYSUT2,DISP=OLD
//SYSOUT   DD SYSOUT=*