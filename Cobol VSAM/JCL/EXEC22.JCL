//EAD62522  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62522                                           *00011003
//**********************************************************************00012003
//STEP1    EXEC PGM=EAD62522
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//VS001    DD DSN=GR.EAD625.ARC.VS.VS001,DISP=SHR
//*VS001    DD DUMMY
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
237