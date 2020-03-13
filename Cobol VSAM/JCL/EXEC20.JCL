//EAD62520  JOB 'EX COB',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID              00010000
//**********************************************************************00010103
//* EXECUTE PROGRAM EAD62520                                           *00011003
//**********************************************************************00012003
//STEP1    EXEC PGM=EAD62520
//STEPLIB  DD DSN=GR.GERAL.LOADLIB,DISP=SHR
//*VS001    DD DSN=GR.EAD625.ARC.VS.VS001,DISP=SHR
//VS001    DD DUMMY
//SYSOUT   DD SYSOUT=*