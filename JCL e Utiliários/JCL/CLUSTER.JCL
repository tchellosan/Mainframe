//CLUSTER  JOB 'EAD625',CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE (GR.EAD625.JOBLIB.KSDS) PURGE CLUSTER
 IF MAXCC = 8 THEN SET MAXCC = 0
 DEFINE CLUSTER                             -
   (NAME(GR.EAD625.JOBLIB.KSDS)             -
    VOL(PR39X7)                             -
    RECORDSIZE(30 30)                       -
    FREESPACE(4 4)                          -
    SHR(2)                                  -
    TRK(1 1)                                -
    KEYS(5 0)                               -
    UNIQUE )                                -
    DATA(NAME(GR.EAD625.JOBLIB.KSDS.DATA))  -
   INDEX(NAME(GR.EAD625.JOBLIB.KSDS.INDEX))