      SUBROUTINE VALUE(KRD,NST)
C
C        PROCESS VALUE COMMAND
C           -CHILD OF KARDIN ROUTINE
C

      INCLUDE 'CEDRIC.INC'      
      PARAMETER (MXCARD=10000,MXDEF=25,MXSUB=100,NREC=5,MVOPT=7)
      COMMON /VOLUME/ INPID(NID),ID(NID),NAMF(4,NFMAX),SCLFLD(NFMAX),
     X                IRCP(NFMAX),MAPVID(NFMAX,2),CSP(3,3),NCX(3),
     X                NCXORD(3),NFL,NPLANE,BAD
      CHARACTER*2 NAMF
      COMMON /DEFVAL/ KIMAGE(MXCARD),NAMBLK(MXDEF),LOCST(MXDEF)
     X               ,LENBLK(MXDEF),NDBLK,ISTORE,IXPAND(NREC)
     X               ,NXPAND(NREC),IX,IVSTAK(2,MXSUB),NSUB,ISFLG,ICFLG
      CHARACTER*8 KIMAGE,NAMBLK,IVSTAK
      CHARACTER*8 IVOPT(MVOPT), CTEMP
      CHARACTER*6 CLAND, CTEMP6
      CHARACTER*(*) KRD(10)
      DATA IVOPT/'NONE    ','SET     ','OFF     ','XON     ',
     X           'DELETE  ','ON      ','SETID   '/
C
C     ITYP INDICATES THE TYPE FOR THE ID WORDS:
C              -2 = ALPHABETIC
C              -1 = UNSCALED INTEGER
C               0 = DEAD WORD
C               1 = SCALED INTEGER (*SF) TRUE VAL = STORED VAL / SF
C               2 = SCALED INTEGER (/SF) TRUE VAL = STORED VAL * SF
C               3 = SCALED INTEGER (*CF) TRUE VAL = STORED VAL / CF
C
      DIMENSION ITYP(NID)
      CHARACTER*1 CIBL
      DATA CIBL/' '/
C
      DATA (ITYP(I),I=1,20)/20*-2/
      DATA (ITYP(I),I=43,58)/16*-2/
      DATA ITYP(62),ITYP(66),ITYP(151)/3*-2/
      DATA (ITYP(I),I=71,94)/24*-2/
      DATA (ITYP(I),I=101,104)/4*-2/
      DATA (ITYP(I),ITYP(I+1),ITYP(I+2),ITYP(I+3),I=176,296,5)/100*-2/
      DATA (ITYP(I),ITYP(I+1),ITYP(I+2),I=306,390,6)/45*-2/
C
C        SET UNSCALED INTEGERS
C
      DATA (ITYP(I),I=21,34), ITYP(35), ITYP(36) /14*-1, 1, -1/
      DATA ITYP(37), ITYP(38), ITYP(39) /-1, 1, -1/
      DATA ITYP(60),ITYP(61),ITYP(63),ITYP(64),ITYP(65)/5*-1/
      DATA (ITYP(I),I=95,100)/6*-1/
      DATA ITYP(106), ITYP(107), ITYP(108), ITYP(109) /-1, 2, 2, 1/
      DATA ITYP(110), ITYP(111) /2*-1/
      DATA (ITYP(I),I=112,115)/4*0/
      DATA (ITYP(I),I=116,129)/14*-1/
      DATA ITYP(130),ITYP(131),ITYP(132),ITYP(133) /2*0, 2*1/
      DATA (ITYP(I),I=134,137),ITYP(138),ITYP(139) /4*-1, 0, -1/
      DATA ITYP(140),ITYP(141) /2*0/
      DATA (ITYP(I),I=142,143),ITYP(144),ITYP(145) /2*3, -1, 3/
      DATA (ITYP(I),I=146,150) /5*-1/
      DATA (ITYP(I),I=152,153),ITYP(154) /2*3,-1/
      DATA (ITYP(I),I=155,156),ITYP(157),ITYP(158) /2*3, -1, 3/
      DATA ITYP(159),ITYP(160),ITYP(161),ITYP(162) /-1, 1, 1, -1/
      DATA ITYP(163),ITYP(164),ITYP(165),ITYP(166) /-1, -1, 1, 1/
      DATA ITYP(167),ITYP(168),ITYP(169),ITYP(170),ITYP(171) /3*-1,2*1/
      DATA (ITYP(I),I=172,175) /4*-1/
      DATA ITYP(67),ITYP(68),ITYP(69),ITYP(301),ITYP(302)/5*-1/
      DATA ITYP(180),ITYP(185),ITYP(190),ITYP(195),ITYP(200)/5*-1/
      DATA ITYP(205),ITYP(210),ITYP(215),ITYP(220),ITYP(225)/5*-1/
      DATA ITYP(230),ITYP(235),ITYP(240),ITYP(245),ITYP(250)/5*-1/
      DATA ITYP(255),ITYP(260),ITYP(265),ITYP(270),ITYP(275)/5*-1/
      DATA ITYP(280),ITYP(285),ITYP(290),ITYP(295),ITYP(300)/5*-1/
      DATA ITYP(303)/-1/
      DATA ITYP(311),ITYP(317),ITYP(323),ITYP(329),ITYP(335)/5*-1/
      DATA ITYP(341),ITYP(347),ITYP(353),ITYP(359),ITYP(365)/5*-1/
      DATA ITYP(371),ITYP(377),ITYP(383),ITYP(389),ITYP(395)/5*-1/
C
C        SET DEAD WORDS
C
      DATA ITYP(59),ITYP(70),ITYP(105)/3*0/
C
C        SET SCALED INTEGERS (*SF)
C
      DATA ITYP(41),ITYP(42)/1,1/
      DATA ITYP(304),ITYP(305)/2*1/
      DATA ITYP(309),ITYP(310),ITYP(315),ITYP(316),ITYP(321)/5*1/
      DATA ITYP(322),ITYP(327),ITYP(328),ITYP(333),ITYP(334)/5*1/
      DATA ITYP(339),ITYP(340),ITYP(345),ITYP(346),ITYP(351)/5*1/
      DATA ITYP(352),ITYP(357),ITYP(358),ITYP(363),ITYP(364)/5*1/
      DATA ITYP(369),ITYP(370),ITYP(375),ITYP(376),ITYP(381)/5*1/
      DATA ITYP(382),ITYP(387),ITYP(388),ITYP(393),ITYP(394)/5*1/
C
C        SET SCALED INTEGERS (*CF)
C
      DATA ITYP(40)/3/

      NST=0
      L=LOCATE(KRD(2),IVOPT,MVOPT)
      GOTO (100,200,300,400,500,600,700),L
C
C        NONE - ZERO OUT STACK
C
 100  CONTINUE
      NSUB=0
      GOTO 1000
C
C        SET VALUE INTO STACK
C
 200  CONTINUE
      IF(KRD(3).EQ.CIBL) THEN
         CALL CEDERX(556,1)
         NST=1
         RETURN
      END IF
      IF(NSUB.EQ.0) GO TO 240
C
C        REDEFINE VARIABLE ASSIGNMENT IF ALREADY PRESENT
C
      DO 230 I=1,NSUB
         IF(IVSTAK(1,I).NE.KRD(3)) GO TO 230
         IVSTAK(2,I)=KRD(5)
         GO TO 1000
 230  CONTINUE
 240  CONTINUE
      IF (NSUB.GE.MXSUB) THEN
         CALL CEDERX(551,1)
         NST=1
         RETURN
      END IF
      NSUB=NSUB+1
      IVSTAK(1,NSUB)=KRD(3)
      IVSTAK(2,NSUB)=KRD(5)
      GOTO 1000
C
C        OFF - VALUES DISABLED
C
 300  CONTINUE
      ISFLG=0
      GOTO 1000
C
C        XON - RECURSIVE ENABLE
C
 400  CONTINUE
      ISFLG=1
      GOTO 1000
C
C        DELETE ENTRY FROM STACK
C
 500  CONTINUE
 510  FORMAT(A8)
      DO 520 I=1,NSUB
         IF (IVSTAK(1,I).EQ.KRD(3)) THEN
            NDEL=I
            GOTO 530
         ENDIF
 520  CONTINUE
      CALL CEDERX(553,0)
      GOTO 1000
 530  CONTINUE
      NREP=(NSUB-NDEL)*2
      CALL COPCX(IVSTAK(1,NDEL),IVSTAK(1,NDEL+1),NREP)
      GOTO 1000
C
C        ON - ENABLE
C
 600  CONTINUE
      ISFLG=-1
      GOTO 1000
C
C     SUBSTITUTE CONTENTS OF AN ID WORD FOR A STRING
C
 700  CONTINUE
      IF (KRD(5).EQ.'VNYQ') THEN
         FVAL=REAL(ID(304))/REAL(ID(68))
         WRITE(CTEMP,23)FVAL
 23      FORMAT(F8.2)
      ELSE IF (KRD(5).EQ.'RCON') THEN
         FVAL=REAL(ID(305))/REAL(ID(68))
         WRITE(CTEMP,23)FVAL
      ELSE IF (KRD(5)(1:3).EQ.'ID(') THEN
         ILOC=INDEX(KRD(5),')')
         IF (ILOC.EQ.5) THEN
            READ(KRD(5),77)IVAL
 77         FORMAT(3X,I1)
         ELSE IF (ILOC.EQ.6) THEN
            READ(KRD(5),79)IVAL
 79         FORMAT(3X,I2)
         ELSE IF (ILOC.EQ.7) THEN
            READ(KRD(5),82)IVAL
 82         FORMAT(3X,I3)
         ELSE
            CALL CEDERX(580,1)
            NST=1
            RETURN
         END IF
         IF (ITYP(IVAL).EQ.-2) THEN
            WRITE(CTEMP,36)ID(IVAL)
 36         FORMAT(A2)
         ELSE IF (ITYP(IVAL).EQ.-1) THEN
            WRITE(CTEMP,27)REAL(ID(IVAL))
 27         FORMAT(F8.0)
         ELSE IF (ITYP(IVAL).EQ.0) THEN
            CALL CEDERX(581,1)
            NST=1
            RETURN
         ELSE IF (ITYP(IVAL).EQ.1) THEN
            WRITE(CTEMP,23)REAL(ID(IVAL))/REAL(ID(68))
         ELSE IF (ITYP(IVAL).EQ.2) THEN
            WRITE(CTEMP,23)REAL(ID(IVAL))*REAL(ID(68))
         ELSE IF (ITYP(IVAL).EQ.3) THEN
            WRITE(CTEMP,23)REAL(ID(IVAL))/REAL(ID(69))
         END IF
      ELSE IF (KRD(5)(1:2).EQ.'X:' .OR. KRD(5)(1:2).EQ.'Y:' .OR.
     X         KRD(5)(1:2).EQ.'Z:') THEN
         IF (KRD(5)(1:1).EQ.'X') THEN
            IAX=0
         ELSE IF (KRD(5)(1:1).EQ.'Y') THEN
            IAX=1
         ELSE
            IAX=2
         END IF
         CLAND=KRD(5)(3:)
         ISAV=0
         DO I=1,MAXLAND
            WRITE(CTEMP6,37)ID(306+(I-1)*6),ID(307+(I-1)*6),
     X           ID(308+(I-1)*6)
 37         FORMAT(3A2)
            IF (CTEMP6.EQ.CLAND) ISAV=I
         END DO
         IF (ISAV.EQ.0) THEN
            CALL CEDERX(582,1)
            NST=1
            RETURN
         ELSE
            IF (IAX.EQ.0 .OR. IAX.EQ.1) THEN
               FVAL=REAL(ID(309+IAX+(ISAV-1)*6))/REAL(ID(68))
            ELSE
               FVAL=REAL(ID(309+IAX+(ISAV-1)*6))
            END IF
            WRITE(CTEMP,23)FVAL
         END IF
      ELSE
         CALL CEDERX(583,1)
         NST=1
         RETURN
      END IF
      IF (NSUB.EQ.0) GOTO 740
C
C     REDEFINE VARIABLE ASSIGNMENT IF ALREADY PRESENT
C
      DO 730 I=1,NSUB
         IF(IVSTAK(1,I).NE.KRD(3)) GO TO 730
         IVSTAK(2,I)=CTEMP
         GO TO 1000
 730  CONTINUE
 740  CONTINUE
      IF (NSUB.GE.MXSUB) THEN
         CALL CEDERX(551,1)
         NST=1
         RETURN
      END IF
      NSUB=NSUB+1
      IVSTAK(1,NSUB)=KRD(3)
      IVSTAK(2,NSUB)=CTEMP

 1000 CONTINUE
      RETURN
      END
