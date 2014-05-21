c
c----------------------------------------------------------------------X
c
      SUBROUTINE SAVRNGE(INDAT,NAMFLD,IFLD,NFLDS,PRMN,PRMX,PAMN,PAMX,
     X                   ASKIP,IRNAM,RFMN,RFMX,RREF,RPRNT,NRP,BDVAL,
     X                   LTYP)
C
C  CONTINUE READING PLTRNGE STACK FOR FIELDS TO BE PLOTTED
C
C     NRP       - NUMBER OF FIELDS PER FRAME
C     IRNAM     - NAMES   "    "
C     RFMN,RFMX - MINIMUM AND MAXIMUM FIELD VALUE
C     RREF      - DASHED REFERENCE LINE(S) ON PLOTS
C     PRMN,PRMX - MINIMUM AND MAXIMUM RANGE (KM)
C     PAMN,PAMX -    "     "     "    ANGLES
C     ASKIP     - ANGLE SKIPPING FACTOR WITHIN THE SWEEP
C     LTYP      - TYPE OF CONNECTION BETWEEN POINTS (LINE or DOTS)
C               - DOTS is the default
C
      INCLUDE 'dim.inc'

      CHARACTER*8 INDAT(10),JNDAT(10)
      CHARACTER*8 NAMFLD(MXF),IRNAM(MXF),RPRNT(MXF),LTYP
      CHARACTER*4 NAMOUT
      DATA NAMOUT/'    '/
      DIMENSION IFLD(MXF)
      DIMENSION RFMN(MXF),RFMX(MXF),RREF(MXF,5),RFYB(MXF),RFYT(MXF)

      NRP=0
      WRITE(6,11)(INDAT(I),I=2,10)
   11 FORMAT(1X,'PRNGE: ',9A8)
      READ(INDAT,13)PRMN,PRMX,PAMN,PAMX,ASKIP,LTYP
   13 FORMAT(/F8.0/F8.0/F8.0/F8.0/F8.0/A8)
      print *,'SAVRNGE: prmn,prmx,pamn,pamx,askip,ltyp=',
     +     prmn,prmx,pamn,pamx,askip,ltyp

C     READ FIELD NAME, MIN VALUE, MAX VALUE UNTIL END-OF-STACK
C
   20 READ(5,21)(JNDAT(I),I=1,10)
   21 FORMAT(10A8)
c      WRITE(6,22)(JNDAT(I),I=1,10)
c   22 FORMAT('Kardin=',10A8)
      IF(JNDAT(1)(1:1).EQ.'*')GO TO 20
      IF(JNDAT(1).EQ.'END     ')RETURN
      IF(JNDAT(1).NE.'        ')THEN
         WRITE(6,23)
   23    FORMAT(1X,'*** SAVRNGE: NO END LINE ENCOUNTERED ***')
         STOP
      END IF
      NRP=NRP+1
      IF(NRP.GT.12)THEN
         WRITE(6,25)
   25    FORMAT(1X,'*** SAVRNGE: NO. PLOTS EXCEEDS 12 - STOP ***')
         STOP
      END IF
      READ(JNDAT,27)IRNAM(NRP),RFMN(NRP),RFMX(NRP),(RREF(NRP,N),N=1,5),
     +     RPRNT(NRP)
   27 FORMAT(/A8/F8.0/F8.0/F8.0/F8.0/F8.0/F8.0/F8.0/A8)
C
      DO N=1,4
         IF(RREF(NRP,N+1).EQ.RREF(NRP,N))THEN
            RREF(NRP,N+1)=BDVAL
            GO TO 28
         END IF
      END DO
 28   CALL FIELD(IRNAM(NRP),NAMFLD,NFLDS,NAMOUT)
      IFL=IFIND(IRNAM(NRP),NAMFLD,NFLDS)
      WRITE(6,29)NRP,NAMFLD(IFL),IFL,IFLD(IFL),RFMN(NRP),RFMX(NRP),
     +           (RREF(NRP,N),N=1,5),RPRNT(NRP)
   29 FORMAT(8X,'NRP= ',I4,4X,A8,2I4,7F8.2,2X,A8)
      IF(IFLD(IFL).LE.-1)THEN
         WRITE(6,31)
   31    FORMAT(1X,'*** THIS TYPE OF FIELD NOT ALLOWED ***')
         NRP=NRP-1
      END IF
      GO TO 20
      END


