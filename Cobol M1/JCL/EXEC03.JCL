//EAD62503  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62503                                           *00011003
//**********************************************************************00012003
//STEP001  EXEC PGM=EAD62503
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SYSIN    DD *
5000
2300
//SYSOUT   DD SYSOUT=*