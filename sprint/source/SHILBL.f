      SUBROUTINE SHILBL(NAME,NNAM)
C
C        SHIFT LEFT AND BLANK FILL
C
      INCLUDE 'SPRINT.INC'
      DIMENSION NAME(NNAM)

      ISHFTAMT=WORDSZ-16
      
      DO 100 I=1,NNAM
         NAME(I)=ICEDSHFT(NAME(I),ISHFTAMT)
 100  CONTINUE
      RETURN
      END