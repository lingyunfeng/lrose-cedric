
      SUBROUTINE COLRAM (XCS,YCS,NCS,IAI,IAG,NAI)
C
C     DOES COLOR FILL BY CHECKING THAT THE GROUP # IS THREE (FROM CONTOURS)
C     AND THE AREA IDENT. # IS BETWEEN 1 AND 35(THE MAX # OF LEVELS)

      PARAMETER(MAXLEV=61)
      COMMON /COLORS/ ICOL(MAXLEV),IAIM
      DIMENSION XCS(*),YCS(*),IAI(*),IAG(*)
      DIMENSION DST(1100),IND(1200)
      

      ISH=0

      DO 101 I=1,NAI
         IF (IAG(I).EQ.3.AND.IAI(I).GT.IAIM.AND.IAI(I).LE.MAXLEV)
     X        ISH=IAI(I)
 101  CONTINUE

      IF (ISH.NE.0) CALL SFSGFA (XCS,YCS,NCS,DST,1100,IND,1200,
     X                           ICOL(ISH-1))

      RETURN

      END