//EAD62505  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62505                                           *00011003
//**********************************************************************00012003
//STEP001  EXEC PGM=EAD62505
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SYSIN    DD *
80
23
80
//SYSOUT   DD SYSOUT=*