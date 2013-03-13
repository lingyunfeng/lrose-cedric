c
c----------------------------------------------------------------------X
c
      SUBROUTINE PRNTFLD(DAT,IOUT,IIN1,IIN2,AZA,ELA,ITP,DROLD,FXANG,R0,
     X     IUNPR,RNGPT,ANGPT,RADIUS,NSCTP,NAZ,IDATE,ITM,H0,NOUT,NIN1,
     X     NIN2,MXR,MXA,MXF,BDVAL)
C
C  PRINT FIELDS (NOUT, NIN1, NIN2) TO UNIT (IUNPR) IF THE POINT IS 
C  WITHIN KM RADIUS OF THE SAMPLE POINT (RANGE,ANGLE)=(RNGPT,ANGPT)
C
      DIMENSION DAT(MXR,MXA,MXF),AZA(MXA,2),ELA(MXA,2)
      DIMENSION ITM(MXA,2)
      CHARACTER*8 NOUT,NIN1,NIN2,SCAN(8),CORD,NSCTP
      DATA SCAN(1),SCAN(3)/'PPI     ','RHI     '/
      DATA RE,REI/17000.0,1.17647E-04/
      DATA TORAD,TODEG/0.017453293,57.29577951/
      
      IF(NAZ.LT.10)RETURN
      READ(NSCTP,9)RISKIP,RJSKIP
 9    FORMAT(2F4.0)
      ISKIP=NINT(RISKIP)
      JSKIP=NINT(RJSKIP)
      IF(ISKIP.EQ.0)ISKIP=1
      IF(JSKIP.EQ.0)JSKIP=1
      WRITE(IUNPR,11)
 11   FORMAT(/)
      IF(ITP.NE.3)THEN
         XPT=RNGPT*SIN(ANGPT*TORAD)
         YPT=RNGPT*COS(ANGPT*TORAD)
         CORD=' (R,A)='
      ELSE
         XPT=RNGPT*COS(ANGPT*TORAD)
         ZPT=RNGPT*TAN(ANGPT*TORAD)+RNGPT*RNGPT/RE+H0
         CORD=' (R,E)='
      END IF
      IDR=NINT(RADIUS/DROLD)
      IR0=NINT((RNGPT-R0)/DROLD)+1
      IR1=IR0-IDR
      IR2=IR0+IDR
      DANG=ATAN(RADIUS/RNGPT)*TODEG
      ANGMN=ANGPT-DANG
      ANGMX=ANGPT+DANG

      DO 110 J=1,NAZ,JSKIP
         ANG=AZA(J,1)
         IF(ANG.LT.0.)ANG=ANG+360.

         IF(ANG.GT.ANGMN.AND.ANG.LT.ANGMX)THEN
            DO 100 I=IR1,IR2,ISKIP
               R=R0+(I-1)*DROLD
               IF(ITP.NE.3)THEN
                  XX=XPT+R*SIN(ANG*TORAD)
                  YY=YPT+R*COS(ANG*TORAD)
               ELSE
                  XX=R*COS(ANG*TORAD)
                  YY=R*TAN(ANG*TORAD)+R*R/RE+H0
               END IF
               IF(IOUT.NE.0)DATOUT=DAT(I,J,IOUT)
               IF(IIN1.NE.0)DATIN1=DAT(I,J,IIN1)
               IF(IIN2.NE.0)DATIN2=DAT(I,J,IIN2)
               IF(IOUT.NE.0.AND.IIN1.NE.0.AND.IIN2.NE.0)THEN
                  WRITE(IUNPR,69)FXANG,CORD,R,ANG,NOUT,NIN1,NIN2,
     +                 DATOUT,DATIN1,DATIN2
 69               FORMAT(1X,' FX=',F5.1,A7,2F8.3,2X,3A8,3F10.3)
               ELSE IF(IOUT.NE.0.AND.IIN1.NE.0.AND.IIN2.EQ.0)THEN
                  WRITE(IUNPR,71)FXANG,CORD,R,ANG,NOUT,NIN1,
     +                 DATOUT,DATIN1
 71               FORMAT(1X,' FX=',F5.1,A7,2F8.3,2X,2A8,2F10.3)
               ELSE IF(IOUT.NE.0.AND.IIN1.EQ.0.AND.IIN2.EQ.0)THEN
                  WRITE(IUNPR,73)FXANG,CORD,R,ANG,NOUT,
     +                 DATOUT
 73               FORMAT(1X,' FX=',F5.1,A7,2F8.3,2X,A8,F10.3)
               END IF
 100        CONTINUE
         END IF

 110  CONTINUE

      RETURN
      END



