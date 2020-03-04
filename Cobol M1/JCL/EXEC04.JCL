//EAD62504  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62504                                           *00011003
//**********************************************************************00012003
//STEP001  EXEC PGM=EAD62504
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SYSIN    DD *
50
23
80
//SYSOUT   DD SYSOUT=*