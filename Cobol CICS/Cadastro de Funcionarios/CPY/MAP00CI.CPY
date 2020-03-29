       01  MAPEXCLI.
           02  FILLER PIC X(12).
           02  DATAL    COMP  PIC  S9(4).
           02  DATAF    PICTURE X.
           02  FILLER REDEFINES DATAF.
             03 DATAA    PICTURE X.
           02  DATAI  PIC X(10).
           02  HORAL    COMP  PIC  S9(4).
           02  HORAF    PICTURE X.
           02  FILLER REDEFINES HORAF.
             03 HORAA    PICTURE X.
           02  HORAI  PIC X(8).
           02  IDFUNCL    COMP  PIC  S9(4).
           02  IDFUNCF    PICTURE X.
           02  FILLER REDEFINES IDFUNCF.
             03 IDFUNCA    PICTURE X.
           02  IDFUNCI  PIC X(4).
           02  NOMEL    COMP  PIC  S9(4).
           02  NOMEF    PICTURE X.
           02  FILLER REDEFINES NOMEF.
             03 NOMEA    PICTURE X.
           02  NOMEI  PIC X(30).
           02  SALINTL    COMP  PIC  S9(4).
           02  SALINTF    PICTURE X.
           02  FILLER REDEFINES SALINTF.
             03 SALINTA    PICTURE X.
           02  SALINTI  PIC X(6).
           02  SALDECL    COMP  PIC  S9(4).
           02  SALDECF    PICTURE X.
           02  FILLER REDEFINES SALDECF.
             03 SALDECA    PICTURE X.
           02  SALDECI  PIC X(2).
           02  DEPTOL    COMP  PIC  S9(4).
           02  DEPTOF    PICTURE X.
           02  FILLER REDEFINES DEPTOF.
             03 DEPTOA    PICTURE X.
           02  DEPTOI  PIC X(3).
           02  DIAADML    COMP  PIC  S9(4).
           02  DIAADMF    PICTURE X.
           02  FILLER REDEFINES DIAADMF.
             03 DIAADMA    PICTURE X.
           02  DIAADMI  PIC X(2).
           02  MESADML    COMP  PIC  S9(4).
           02  MESADMF    PICTURE X.
           02  FILLER REDEFINES MESADMF.
             03 MESADMA    PICTURE X.
           02  MESADMI  PIC X(2).
           02  ANOADML    COMP  PIC  S9(4).
           02  ANOADMF    PICTURE X.
           02  FILLER REDEFINES ANOADMF.
             03 ANOADMA    PICTURE X.
           02  ANOADMI  PIC X(4).
           02  IDADEL    COMP  PIC  S9(4).
           02  IDADEF    PICTURE X.
           02  FILLER REDEFINES IDADEF.
             03 IDADEA    PICTURE X.
           02  IDADEI  PIC X(2).
           02  EMAILL    COMP  PIC  S9(4).
           02  EMAILF    PICTURE X.
           02  FILLER REDEFINES EMAILF.
             03 EMAILA    PICTURE X.
           02  EMAILI  PIC X(30).
           02  LITCONFL    COMP  PIC  S9(4).
           02  LITCONFF    PICTURE X.
           02  FILLER REDEFINES LITCONFF.
             03 LITCONFA    PICTURE X.
           02  LITCONFI  PIC X(23).
           02  VALCONFL    COMP  PIC  S9(4).
           02  VALCONFF    PICTURE X.
           02  FILLER REDEFINES VALCONFF.
             03 VALCONFA    PICTURE X.
           02  VALCONFI  PIC X(1).
           02  FASEL    COMP  PIC  S9(4).
           02  FASEF    PICTURE X.
           02  FILLER REDEFINES FASEF.
             03 FASEA    PICTURE X.
           02  FASEI  PIC X(1).
           02  MSGL    COMP  PIC  S9(4).
           02  MSGF    PICTURE X.
           02  FILLER REDEFINES MSGF.
             03 MSGA    PICTURE X.
           02  MSGI  PIC X(79).
       01  MAPEXCLO REDEFINES MAPEXCLI.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  DATAO  PIC X(10).
           02  FILLER PICTURE X(3).
           02  HORAO  PIC X(8).
           02  FILLER PICTURE X(3).
           02  IDFUNCO  PIC X(4).
           02  FILLER PICTURE X(3).
           02  NOMEO  PIC X(30).
           02  FILLER PICTURE X(3).
           02  SALINTO PIC ZZZZZ9.
           02  FILLER PICTURE X(3).
           02  SALDECO PIC 99.
           02  FILLER PICTURE X(3).
           02  DEPTOO  PIC X(3).
           02  FILLER PICTURE X(3).
           02  DIAADMO PIC 99.
           02  FILLER PICTURE X(3).
           02  MESADMO PIC 99.
           02  FILLER PICTURE X(3).
           02  ANOADMO PIC 9999.
           02  FILLER PICTURE X(3).
           02  IDADEO PIC 99.
           02  FILLER PICTURE X(3).
           02  EMAILO  PIC X(30).
           02  FILLER PICTURE X(3).
           02  LITCONFO  PIC X(23).
           02  FILLER PICTURE X(3).
           02  VALCONFO  PIC X(1).
           02  FILLER PICTURE X(3).
           02  FASEO  PIC X(1).
           02  FILLER PICTURE X(3).
           02  MSGO  PIC X(79).