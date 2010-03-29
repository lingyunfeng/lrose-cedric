      SUBROUTINE GUIPROC(KRD)
C
C     PROCESSES COMMANDS RELATED TO THE CEDRIC GUI
C
      COMMON /GUI/ IFATAL,IGUISTAT
      COMMON /FRAMES/ IFRAME
      CHARACTER*8 KRD(10), CTEMP
      CHARACTER*20 CTEMP2
      CHARACTER*80 FNAME,CDUM
      DATA FNAME/'gmeta'/
      DATA LASTFRM /0/

      READ(KRD,20)CTEMP
 20   FORMAT(/A8)

      IF (CTEMP.EQ.'ERRORS') THEN
         READ(KRD,30)CTEMP2
 30      FORMAT(//A8)
         IF (CTEMP2.EQ.'OFF') THEN
C     CEDRIC ERRORS WILL NOT BE FATAL; USEFUL FOR INTERACTIVE USE WITH GUI
            IFATAL=0
         ELSE
C     CEDRIC ERRORS WILL BE FATAL; USEFUL FOR BATCH MODE
            IFATAL=1
         END IF
      ELSE IF (CTEMP.EQ.'META') THEN
         CALL GDAWK(1)
         CALL GCLWK(1)
         IF (IFRAME.GT.LASTFRM) THEN
C     IF FILE HAS FRAMES IN IT, SEND A MESSAGE TO START UP IDT
            CALL CEDGUI('ASYNC','plotsdone')
            CALL CEDGUI('ASYNC',FNAME)
            LASTFRM=IFRAME
         END IF
         READ(KRD,30)FNAME
         CALL GESC(-1391,1,FNAME,1,1,CDUM)
         CALL GOPWK(1,2,1)
         CALL GACWK(1)
         CALL GSCLIP(0)
         CALL DFCLRS(0)
         CALL PCSETC('FC','&')
      ELSE IF (CTEMP.EQ.'STATUS') THEN
         WRITE(CTEMP2,50)IGUISTAT
 50      FORMAT("STATUS ",I2)
         CALL CEDGUI('SYNC',CTEMP2)
      END IF
      RETURN

      END