      SUBROUTINE REGRZI
C
C        INITIALIZES THE VOLUME ACCUMULATORS FOR THE REGRESSION COMPUTATION
C
      DOUBLE PRECISION SXV,SYV,CXYV,FSQXV,FSQYV
      COMMON /REGRBF/ NRV
      COMMON /REGRBF2/ SXV,SYV,CXYV,FSQXV,FSQYV
C
      NRV=0
      SXV=0.0
      SYV=0.0
      CXYV=0.0
      FSQXV=0.0
      FSQYV=0.0
C
      RETURN
      END