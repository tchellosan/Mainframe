//DELVSAM  JOB 'EAD625',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE GR.EAD625.JOBLIB.SEQ PURGE
 DELETE GR.EAD625.JOBLIB.SEQ PURGE
//*DELETE GR.EAD625.JOBLIB.KSDS PURGE CLUSTER