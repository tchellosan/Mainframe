       01  MAPCALCI.
           02  FILLER PIC X(12).
           02  CODTRANL    COMP  PIC  S9(4).
           02  CODTRANF    PICTURE X.
           02  FILLER REDEFINES CODTRANF.
             03 CODTRANA    PICTURE X.
           02  CODTRANI  PIC X(4).
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
           02  N1L    COMP  PIC  S9(4).
           02  N1F    PICTURE X.
           02  FILLER REDEFINES N1F.
             03 N1A    PICTURE X.
           02  N1I  PIC 9(4).
           02  OPL    COMP  PIC  S9(4).
           02  OPF    PICTURE X.
           02  FILLER REDEFINES OPF.
             03 OPA    PICTURE X.
           02  OPI  PIC X(1).
           02  N2L    COMP  PIC  S9(4).
           02  N2F    PICTURE X.
           02  FILLER REDEFINES N2F.
             03 N2A    PICTURE X.
           02  N2I  PIC 9(4).
           02  RESULTL    COMP  PIC  S9(4).
           02  RESULTF    PICTURE X.
           02  FILLER REDEFINES RESULTF.
             03 RESULTA    PICTURE X.
           02  RESULTI  PIC X(9).
           02  MSGL    COMP  PIC  S9(4).
           02  MSGF    PICTURE X.
           02  FILLER REDEFINES MSGF.
             03 MSGA    PICTURE X.
           02  MSGI  PIC X(79).
       01  MAPCALCO REDEFINES MAPCALCI.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  CODTRANO  PIC X(4).
           02  FILLER PICTURE X(3).
           02  DATAO  PIC X(10).
           02  FILLER PICTURE X(3).
           02  HORAO  PIC X(8).
           02  FILLER PICTURE X(3).
           02  N1O  PIC X(4).
           02  FILLER PICTURE X(3).
           02  OPO  PIC X(1).
           02  FILLER PICTURE X(3).
           02  N2O  PIC X(4).
           02  FILLER PICTURE X(3).
           02  RESULTO PIC --------9.
           02  FILLER PICTURE X(3).
           02  MSGO  PIC X(79).