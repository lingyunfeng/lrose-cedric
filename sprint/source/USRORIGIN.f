      SUBROUTINE USRORIGIN(KRD,RADAR_CHOSEN,ANGXAX)
C
C     Allows user to specify information about the radar and origin
C     rather than using only the existing Tables in INPFIL.  Currently 
C     uses NEXRAD network information in the file nexrad_radar_sites.txt 
C     which must be available to directory where SPRINT is executed.
C
C     User-specified parametes:
C        EXP - Experiment name (currently only NEXRAD table is available)
C              If NEXRAD, RADAR_NAME and ORIGIN_NAME refer to NEXRADs; 
C              otherwise these names are used only for the output header.
C              NEXRAD lat-lons are looked up if only a name is specified;
C              otherwise, the user-specified lat-lons are used.
C
C        RADAR_NAME           - Four-letter NWS designation of a NEXRAD
C        RADLAT,RADLON,RADALT - Radar latitude, longitude, and altitude (m)
C        ORIGIN_NAME          - Four-letter NWS designation of a NEXRAD
C        ORLAT,ORLON,ORALT    - Origin latitude, longitude, and altitude (m)
C     Note: If the origin is not specified, then it is set to the radar.
C
      INCLUDE 'SPRINT.INC'
c      PARAMETER (MAXEL=150,NID=129+3*MAXEL)

      PARAMETER (NRMX=26,NEXP=27)

      COMMON /CINPC/ NMRAD,ITAP,TAPE_UNIT
      COMMON /CINP/IUN,ISKP,ORLAT,ORLON
      COMMON /RINP/RADLAT,RADLON,RADALT
      COMMON /IDBLK/ID(NID)

      CHARACTER*8 KRD(10)
      CHARACTER*4 NMRAD,NMORG
      CHARACTER*8 ITAP
      CHARACTER*8 TAPE_UNIT
      CHARACTER*8 EXP,RADAR_NAME,ORIGIN_NAME
      REAL XRAD,YRAD
      REAL ORLAT,ORLON,ORALT,RADLAT,RADLON,RADALT
      REAL*4  RTEMP,RFRACT,SEC
      INTEGER POS,POS_RAD,POS_ORG,USER_ORLAT,USER_RADLAT
      INTEGER DEG,MIN,ISEC
      INTEGER NEXRAD_DATA,RADAR_CHOSEN

      CHARACTER*8 BLANK
      DATA BLANK/'        '/

C LL2XYDRV(RLAT,RLON,XRAD,YRAD,ORLAT,ORLON,ANGXAX) FINDS THE X AND Y DISTANCE
C IN KM BETWEEN THE RADAR AND THE ORIGIN.  IT IS PUT IN THE CEDRIC HEADER.  
C Note that LL2XY uses the convention that WEST (EAST) longitude is NEGATIVE 
C (POSITIVE), but the NEXRAD table has EAST longitude as NEGATIVE.  Lat-Lons 
C are interpreted as degrees, not deg:min:sec.

C SEE IF THERE ARE USER SPECIFIED ORIGIN AND RADAR LAT-LONs.
C
      USER_ORLAT  = 0
      USER_RADLAT = 0
      READ (KRD,101)EXP,RADAR_NAME,RADLAT,RADLON,RADALT,
     X     ORIGIN_NAME,ORLAT,ORLON,ANGTMP
 101  FORMAT(/A8/A8/F8.0/F8.0/F8.0/A8/F8.0/F8.0/F8.0)
      IF(KRD(10).NE.BLANK)ANGXAX=ANGTMP

      IF(RADLAT .NE. 0.0) USER_RADLAT = 1
      IF(ORLAT  .NE. 0.0) USER_ORLAT = 1

C SEE IF WE HAVE NEXRAD OR NON-NEXRAD NETWORK.
C
      IF(EXP(1:8) .EQ. 'NEXRAD')THEN
         NEXRAD_DATA = 1
      ELSE IF(EXP(1:8) .EQ. 'WSR88D')THEN
         NEXRAD_DATA = 1
      ELSE IF(EXP(1:8) .EQ. 'NOWRAD')THEN
         NEXRAD_DATA = 1
      ELSE 
         NEXRAD_DATA = 0
      END IF

      NMRAD = RADAR_NAME(1:4)
      NMORG = ORIGIN_NAME(1:4)
      ORALT = 0.0
      
C NON-NEXRAD NETWORK:
C     IF THE USER ENTERED NEITHER AN ORIGIN LAT-LON NOR A RADAR LAT-LON 
C     AND THE DATA TYPE AN ERROR HAS OCCURRED SO EXIT.  EITHER ORIGIN OR 
C     RADAR LAT-LON MUST BE SPECIFIED.
C      
      IF(NEXRAD_DATA .EQ. 0)THEN
         IF(USER_RADLAT .EQ. 0 .AND. USER_ORLAT .EQ. 0) THEN
C
C           Neither radar or origin specified
C
            PRINT 111
 111        FORMAT(/,
     X 6x,'    +++ ERROR - FOR NON NEXRAD NETWORKS +++   ',/,
     X 6x,'SPECIFY EITHER RADAR OR ORIGIN LAT-LON OR BOTH',/)
            STOP
         END IF

         IF(USER_RADLAT .EQ. 1 .AND. USER_ORLAT .EQ. 0) THEN
C
C           Radar specified, but not origin: set origin = radar
C
            ORLAT=RADLAT
            ORLON=RADLON
            ORALT=RADALT
            ORIGIN_NAME=RADAR_NAME
         END IF

         IF(USER_RADLAT .EQ. 0 .AND. USER_ORLAT .EQ. 1) THEN
C
C           Origin specified, but not radar: set radar = origin
C
            RADLAT=ORLAT
            RADLON=ORLON
            RADALT=ORALT
            RADAR_NAME=ORIGIN_NAME
         END IF

         CALL LL2XYDRV(RADLAT,RADLON,XRAD,YRAD,ORLAT,ORLON,ANGXAX)
         ID(46) = RADALT 
         ID(47) = XRAD * 100
         ID(48) = YRAD * 100
         GO TO 180
      ENDIF

C NEXRAD NETWORK:
C     IF THE USER DID NOT ENTER RADAR AND/OR ORIGIN LAT-LON, TRY
C     LOOKUPS IN NEXRAD NETWORK FILE (nexrad_radar_sites.txt)
C
      POS_ORG = INDEX(ORIGIN_NAME,' ')
      POS_RAD = INDEX(RADAR_NAME,' ')

      IF( (USER_ORLAT .EQ. 0 .AND. USER_RADLAT .EQ. 0) .AND.
     X    (POS_ORG .LE. 1 .AND. POS_RAD .LE. 1)) THEN
         PRINT 113
 113     FORMAT(/,
     X 6x,'          +++ ERROR - NEXRAD NETWORK +++          ',/,
     X 6x,'SPECIFY EITHER RADAR OR ORIGIN INFORMATION OR BOTH',/)
         STOP
      END IF

      IF(USER_RADLAT .EQ. 0)THEN
C
C        No radar lat-lon specified, try look up
C
         IF(POS_RAD .LE. 1)THEN
            PRINT 115
 115        FORMAT(/,
     X 6x,'+++ ERROR - ENTER NEXRAD FOUR LETTER RADAR NAME +++',/)
            STOP
         ELSE
            CALL GET_RADAR_LOCATION(RADLAT,RADLON,RADALT,NMRAD)
         END IF
      END IF

      IF(USER_ORLAT .EQ. 0)THEN
C
C        No origin lat-lon specified, look up or set to radar
C
         IF(POS_ORG .LE. 1)THEN
C
C           No origin name specified, set origin = radar
C
            ORLAT=RADLAT
            ORLON=RADLON
            ORALT=0.0
            ORIGIN_NAME=RADAR_NAME
            NMORG=NMRAD
         ELSE
C     
C           Origin name specified, look up lat-lon
C     
            CALL GET_RADAR_LOCATION(ORLAT,ORLON,ORALT,NMORG)
         END IF
      END IF
      
      CALL LL2XYDRV(RADLAT,RADLON,XRAD,YRAD,ORLAT,ORLON,ANGXAX)
      ID(46) = RADALT 
      ID(47) = XRAD * 100
      ID(48) = YRAD * 100

      POS = INDEX(RADAR_NAME,' ')
      IF(POS .gt. 1)THEN
         RADAR_CHOSEN = 1
      END IF

 180  PRINT 200
 200  FORMAT(//5X,'SUMMARY OF ORIGIN COMMAND')
      PRINT 201
 201  FORMAT(  5X,'------- -- ------ -------')
      PRINT 202,EXP,ORIGIN_NAME,ORLAT,ORLON,ORALT,
     X     RADAR_NAME,RADLAT,RADLON,RADALT,
     X     XRAD,YRAD,ANGXAX
 202  FORMAT(/20X,'     EXPERIMENT : ',A8
     X       /20X,'    ORIGIN NAME : ',A4
     X       /20X,'ORIGIN LATITUDE : ',F10.4
     X       /20X,'ORIGIN LONGITUDE: ',F10.4
     X       /20X,'ORIGIN ALT (m)  : ',F10.1
     X       /20X,'     RADAR NAME : ',A4
     X       /20X,'RADAR  LATITUDE : ',F10.4
     X       /20X,'RADAR  LONGITUDE: ',F10.4
     X       /20X,'RADAR  ALT (m)  : ',F10.1
     X       /20X,'RADAR  X (km)   : ',F10.3
     X       /20X,'RADAR  Y (km)   : ',F10.3
     X       /20X,'AZIMUTH +X AXIS : ',F10.1//)

C CONVERT THE ORLAT AND ORLON INTO DEG MIN SEC SO IT CAN BE PUT
C IN THE CEDRIC MUDRAS HEADER. IDMUD(33) - IDMUD(38)
C
      DEG    = int(ORLAT)
      RTEMP  = ORLAT - REAL(DEG)
      RFRACT = RTEMP * 3600.
      MIN    = INT(RFRACT)/60
      SEC    = RFRACT - 60. * FLOAT(MIN)
      ISEC   = INT(SEC)
      ORLAT  = 10000*DEG + 100*MIN + ISEC

      DEG    = int(ORLON)
      RTEMP  = ORLON - REAL(DEG)
      RFRACT = RTEMP * 3600.
      MIN    = INT(RFRACT)/60
      SEC    = RFRACT - 60. * FLOAT(MIN)
      ISEC   = INT(SEC)
      ORLON  = 10000*DEG + 100*MIN + ISEC      

      RETURN
      END
      