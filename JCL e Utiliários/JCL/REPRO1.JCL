//REPRO1   JOB 'EAD625',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 REPRO IFILE(ENTRADA) OFILE(SAIDA)
//ENTRADA  DD DSN=GR.EAD625.JOBLIB.SEQ,DISP=SHR
//SAIDA    DD DSN=GR.EAD625.JOBLIB.KSDS,DISP=SHR