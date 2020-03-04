//EAD62501  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62501                                           *00011003
//**********************************************************************00012003
//STEP001  EXEC PGM=EAD62501
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SYSOUT   DD SYSOUT=*