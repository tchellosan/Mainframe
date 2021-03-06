//IGYWCL  PROC SYSLBLK=3200,
//             LIBPRFX='CEE'
//*
//COB2    EXEC PGM=IGYCRCTL,
//             PARM=(LIB,NONUM,OBJ,TERM,NOXREF,LIST,
//             NOSEQ,'DATA(31)',TEST),
//             REGION=4096K
//STEPLIB  DD  DSN=IGY330.SIGYCOMP,DISP=SHR
//SYSTERM  DD  DUMMY
//SYSPRINT DD  SYSOUT=*
//SYSLIB   DD  DSN=&LIB1..BOOKLIB,DISP=SHR
//SYSLIN   DD  DSNAME=&&LOADSET,UNIT=SYSDA,
//             DISP=(MOD,PASS),SPACE=(TRK,(3,3)),
//             DCB=(BLKSIZE=&SYSLBLK)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT4   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT5   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT6   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSUT7   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSIN    DD  DSN=&LIB1..COBLIB(&NOME),DISP=SHR
//************************************************************
//LKED     EXEC PGM=HEWL,COND=(5,LT),REGION=1024K,
//         PARM='LIST,XREF,AMODE=31'
//SYSLIB   DD  DSNAME=&LIBPRFX..SCEELKED,DISP=SHR
//         DD  DSN=CSF.SCSFMOD0,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSLIN   DD  DSNAME=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DSN=&LIB2..LOADLIB(&NOME),DISP=SHR
//SYSUT1   DD  UNIT=SYSDA,SPACE=(TRK,(10,10))
//SYSPRINT DD  SYSOUT=*
//CEEDUMP  DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSOUT   DD  SYSOUT=*