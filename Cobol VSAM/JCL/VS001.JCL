//EAD625VS JOB CLASS=C,MSGCLASS=X,NOTIFY=&SYSUID
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DELETE (GR.EAD625.ARC.VS.VS001) PURGE CLUSTER
 IF MAXCC=8 THEN SET MAXCC=0
 DEFINE CLUSTER(NAME(GR.EAD625.ARC.VS.VS001)       -
                   IXD                             -
                   KEYS(3 0)                       -
                   VOL(PR39T7)                     -
                   RECORDSIZE(33 33)               -
                   TRK(1 1)                        -
                   UNIQUE                          -
                   FREESPACE(4 4)                  -
                   SHR(2))                         -
           DATA(NAME(GR.EAD625.ARC.VS.VS001.DATA)) -
          INDEX(NAME(GR.EAD625.ARC.VS.VS001.INDEX))