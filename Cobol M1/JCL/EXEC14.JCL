//EAD62514  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62514                                           *00011003
//**********************************************************************00012003
//STEP3    EXEC PGM=EAD62514
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//SYSOUT   DD SYSOUT=*