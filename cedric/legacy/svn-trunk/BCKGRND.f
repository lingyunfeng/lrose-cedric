      SUBROUTINE BCKGRND(KRD,LPR)

      CHARACTER*8 KRD(10)

      IF (KRD(2).EQ.'WHITE') THEN
         CALL DFCLRS(2)
         WRITE(LPR,20)
 20      FORMAT(/,5X,'SETTING BACKGROUND COLOR TO WHITE FOR ALL PLOTS')
      ELSE
         CALL DFCLRS(3)
         WRITE(LPR,30)
 30      FORMAT(/,5X,'SETTING BACKGROUND COLOR TO BLACK FOR ALL BUT',
     X        ' GREY SCALE PLOTS')
      END IF

      RETURN

      END

