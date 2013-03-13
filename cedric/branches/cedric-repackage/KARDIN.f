      SUBROUTINE KARDIN(KRD)
C
C
C        RETURNS EXECUTABLE CARD IMAGE
C           -INCLUDES HOUSEKEEPING OF DEFINE,EXPAND AND VALUE
C            DATA STRUCTURES
C
C
C
C        COMMON /DEFVAL/
C           KIMAGE   -  CARD IMAGES    1 CARD=10 WORDS=10A8
C           NAMBLK   -  NAME OF DEFINE BLOCKS
C           LOCST    -  LOCATION OF STARTING WORD
C           LENBLK   -  LENGTH OF BLOCK IN CARDS (10 WORDS PER CARD)
C           NDBLK    -  NUMBER OF DEFINE BLOCKS
C           ISTORE   -  CURRENT POSITION FOR STORAGE IN KIMAGE
C           IXPAND   -  POINTER TO WORD OF CURRENT EXPAND
C           NXPAND   -  NUMBER OF CURRENT EXPAND
C           IX       -  RECURSIVE LEVEL OF EXPAND
C           IVSTAK   -  SUBSTITUTION STACK
C           NSUB     -  NUMBER OF SUBSTITUTIONS
C           ISFLG    -  FLAG FOR SUBSTITUTIONS    (-1=ON,0=OFF,1=XON)
C           ICFLG    -  COMMENT ONLY FLAG         ( 1=IGNORE CONTROL WORDS )
C
C
C
      PARAMETER (MXCARD=10000,MXDEF=25,MXSUB=100,NREC=5)
      COMMON /DEFVAL/ KIMAGE(MXCARD),NAMBLK(MXDEF),LOCST(MXDEF)
     X               ,LENBLK(MXDEF),NDBLK,ISTORE,IXPAND(NREC)
     X               ,NXPAND(NREC),IX,IVSTAK(2,MXSUB),NSUB,ISFLG,ICFLG
      CHARACTER*8 KIMAGE,NAMBLK,IVSTAK
      COMMON /UNITS/ LIN,LOUT,LPR,LSPOOL
      COMMON /GUI/ IFATAL,ISTATGUI
      CHARACTER*(*) KRD(10)
      CHARACTER LINE*130, LINT*90, IDCHAR*1, IBL*1, ICHR*1, IAST*1
      CHARACTER*1 ICHK
      DATA NDBLK,ISTORE,IXPAND,NXPAND,IX,NSUB,ISFLG,ICFLG/16*0/
C
      DATA INDENT/3/
      DATA IDCHAR,IBL/'.',' '/
      DATA IAST/'*'/
      DATA MAR/2/
C
 10   CONTINUE
      IP=MAR+IX*INDENT
      IF (IX.EQ.0) GOTO 200
      LOCN=NXPAND(IX)
      LCUR=(IXPAND(IX)-LOCST(LOCN))/10 + 0.005
      IF (LCUR.EQ.LENBLK(LOCN)) THEN
         IX=IX-1
         GOTO 10
      ENDIF
C
C        INSIDE EXPAND BLOCK
C
      LOCX=IXPAND(IX)
C      DO 125 I=1,10
C         READ (KRD(I),135)IKRD(I)
C 125  CONTINUE
 135  FORMAT(A8)
      CALL COPCX(KRD,KIMAGE(LOCX),10)
C      DO 145 I=1,10
C         WRITE (KRD(I),135)IKRD(I)
C 145  CONTINUE
      LINE=IBL
      IF(IP.GT.MAR) THEN
C
C        INDENT THE CARD IMAGE ON THE OUTPUT LISTING
C
         IPM1=IP-1
         IPM2=IP-2
         DO 15 I=MAR,IPM1
            LINE(I:I)=IDCHAR
   15    CONTINUE
         WRITE (ICHR,602)IX
  602    FORMAT(I1)
         LINE(IPM2:IPM2)=ICHR
      END IF
      WRITE (LINT,600)KRD
  600 FORMAT('>>>>>',10A8,'<<<<<')
      LINE(IP:)=LINT
      IXPAND(IX)=IXPAND(IX)+10
      IF(ICFLG.NE.0) GO TO 550
      IF (KRD(1).EQ.'EXPAND  ') THEN
      WRITE(LPR,601) LINE
         CALL EXPAND(KRD)
         GOTO 10
      ELSE IF(KRD(1).EQ.'VALUE   ') THEN
         WRITE(LPR,601) LINE
         CALL VALUE(KRD,NST)
c         IF (NST.NE.0) RETURN
         GO TO 10
         ENDIF
      GOTO 500
C
C        READ CARD AND PROCESS
C
 200  CONTINUE
      CALL RDKARD(KRD)
      LINE=IBL
      WRITE (LINT,600)KRD
      LINE(IP:)=LINT
      IF(ICFLG.NE.0) GO TO 550
      IF (KRD(1).EQ.'DEFINE  ') THEN
         WRITE(LPR,601) LINE
         ISTATGUI=1
         CALL DEFINE(KRD)
         GOTO 200
      ELSE IF (KRD(1).EQ.'EXPAND  ') THEN
         WRITE(LPR,601) LINE
         ISTATGUI=1
         CALL EXPAND(KRD)
         GOTO 10
      ELSE IF (KRD(1).EQ.'VALUE   ') THEN
         WRITE(LPR,601) LINE
         ISTATGUI=1
         CALL VALUE(KRD,NST)
c         IF (NST.NE.0) RETURN
         GOTO 200
      ELSE IF (KRD(1).EQ.'GUI') THEN
         CALL GUIPROC(KRD)
         GOTO 200
      ENDIF
      ISTATGUI=1
C
C        CHECK CARD FOR SUBSTITUTIONS
C
 500  CONTINUE
C
C     ASTERISK IN COL. 1 MAKES THIS A COMMENT
C
      READ (KRD,603)ICHK
  603 FORMAT(A1)
      IF(ISFLG.EQ.0.OR.NSUB.EQ.0.OR.ICHK.EQ.IAST) GO TO 550
      DO 520 J=2,10
C  TRANSFER TO INT ARRAY
C         READ (KRD(J),515)IKRD(J)
 515     FORMAT(A8)
         DO 510 I=1,NSUB
            IF (KRD(J).EQ.IVSTAK(1,I)) THEN
               KRD(J)=IVSTAK(2,I)
C               WRITE (KRD(J),515)IKRD(J)
               IF (ISFLG.LT.0) GOTO 520
            ENDIF
 510     CONTINUE
 520  CONTINUE
      WRITE (LINT,600)KRD
      LINE(IP:)=LINT
 550  CONTINUE
      WRITE (LPR,601) LINE
  601 FORMAT(A)
C
C     LOOP BACK IF THIS WAS A COMMENT
C
      IF(ICHK.EQ.IAST) GO TO 10
C
      RETURN
      END