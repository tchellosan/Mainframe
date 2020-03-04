//EAD62507  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62507                                           *00011003
//**********************************************************************00012003
//STEP001  EXEC PGM=EAD62507
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SYSIN    DD *
0050000
120
060
//SYSOUT   DD SYSOUT=*