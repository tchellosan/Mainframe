//EAD62508  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62508                                           *00011003
//**********************************************************************00012003
//STEP001  EXEC PGM=EAD62508
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SYSIN    DD *
001000000
0040000
100
//SYSOUT   DD SYSOUT=*