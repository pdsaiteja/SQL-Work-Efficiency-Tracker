USE [LeetCode]
GO
/****** Object:  StoredProcedure [dbo].[CreateZoneEntryExitSim]    Script Date: 4/8/2021 4:06:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[CreateZoneEntryExitSim]

--EXEC [dbo].[CreateZoneEntryExitSim]

AS

BEGIN
DECLARE @DAYS INT

SELECT @DAYS = DATEDIFF(DAY, MIN(workorderSTARTtime), max(workorderendtime)) FROM workorder 

DECLARE @Shift INT
-- Shift start and end
DECLARE @DST DATETIME
SET @DST = '2021-03-31 09:00:00.000'
DECLARE @NST DATETIME
SET @NST = '2021-03-31 21:00:00.00'

DECLARE @WST DATETIME
SET @WST = '2021-04-01 09:00:00.000'
DECLARE @WET DATETIME
SET @WET = '2021-04-30 00:00:00.000'

declare @tiz int
DECLARE @EXITTIME DATETIME 

DECLARE @TOTALHOURS INT
DECLARE @DAYEXITTIME DATETIME

DECLARE @Random INT


DECLARE @LOOPCOUNT INT
SET @LOOPCOUNT = 1


--NOP : NUMBER OF PERSONS

DECLARE @NOP  INT
 SELECT @NOP =  COUNT(*) FROM PERSON;

DECLARE @OUTERLOOP INT
 SET @OUTERLOOP = 1


 DECLARE @ZONEID INT


 DECLARE @NightEXITTIME DATETIME
DECLARE @EXITTIME_N DATETIME

While  @OUTERLOOP <= @NOP

----$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
BEGIN

PRINT(@OUTERLOOP)


			WHILE @LOOPCOUNT <= @DAYS

---!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			BEGIN


			---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					IF (SELECT ShiftId FROM PERSON WHERE PERSONID  = @OUTERLOOP) = 1 
				
					BEGIN
							PRINT('I AM IN SHIFT IF STATEMENT')
							SET @TOTALHOURS =  (SELECT FLOOR(RAND()*(13-11)+11));
							SET @DAYEXITTIME = DATEADD(HOUR, @TOTALHOURS, @DST)
							SET @EXITTIME = @DST


								WHILE @EXITTIME <= @DAYEXITTIME

								--#######################################
									BEGIN
										---SETTING AREA ID
										PRINT('I AM IN SHIFT INNEREST LOOP')
										
										SET @Random = (SELECT FLOOR(RAND()*(101-0)+0))
												IF @Random < 50 + @LOOPCOUNT
					
												BEGIN
														SET @ZONEID = (SELECT FLOOR(RAND()*((max(AreaId) + 1) - min(AreaId))+min(AreaId)) from Areapersonmapping where personid = @OUTERLOOP)

														END;

														else 
														BEGIN
														SET @ZONEID = 9
					
												 END;

												SET @TIZ =  FLOOR(RAND()*(101-0)+0);

												SET @EXITTIME = DATEADD(MINUTE, @TIZ, @DST)

												INSERT INTO [dbo].[AreaChanges]
																	   (
																	   [PersonId]
																	   ,[AreaId]
																	   ,[StartDateTime]
																	   ,[EndDateTime])
																 VALUES
																	  (
																	   @OUTERLOOP
																	   ,@ZONEID
																	   ,@DST
																	   ,@EXITTIME)
												SET @DST = @EXITTIME
				
								  END;
						---#####################################################
						SET @DST = DATEADD(DAY, @LOOPCOUNT, '2021-03-31 09:00:00.000')
							  
						END;
	-------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



	----%%%%%%%%%%%%%%
					ELSE IF (SELECT ShiftId FROM PERSON WHERE PERSONID  = @OUTERLOOP) = 2
				
					BEGIN
							PRINT('I AM IN SHIFT IF STATEMENT')
							SET @TOTALHOURS =  (SELECT FLOOR(RAND()*(13-11)+11));

							SET @NightEXITTIME = DATEADD(HOUR, @TOTALHOURS, @NST)
							SET @EXITTIME_N = @NST


								WHILE @EXITTIME_N <= @NightEXITTIME

								--#######################################
									BEGIN
										---SETTING AREA ID
										PRINT('I AM IN SHIFT INNEREST LOOP')
										
										SET @Random = (SELECT FLOOR(RAND()*(101-0)+0))
												IF @Random < 50 + @LOOPCOUNT
					
												BEGIN
														SET @ZONEID = (SELECT FLOOR(RAND()*((max(AreaId) + 1) - min(AreaId))+min(AreaId)) from Areapersonmapping where personid = @OUTERLOOP)

														END;

														else 
														BEGIN
														SET @ZONEID = 9
					
												 END;

												SET @TIZ =  FLOOR(RAND()*(101-0)+0);

												SET @EXITTIME_N = DATEADD(MINUTE, @TIZ, @NST)

												INSERT INTO [dbo].[AreaChanges]
																	   (
																	   [PersonId]
																	   ,[AreaId]
																	   ,[StartDateTime]
																	   ,[EndDateTime])
																 VALUES
																	  (
																	   @OUTERLOOP
																	   ,@ZONEID
																	   ,@NST
																	   ,@EXITTIME_N)
												SET @NST = @EXITTIME_N
				
								  END;
						---#####################################################
						--SET @DST = DATEADD(DAY, @LOOPCOUNT, '2021-03-31 09:00:00.000')
						SET @NST = DATEADD(DAY, @LOOPCOUNT, '2021-03-31 21:00:00.000')
							  
						END
	-------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	-----%%%%%%%%%%%%%%%%%%%%%%%%%
				

			--SELECT * FROM AREACHANGES;

			PRINT(@LOOPCOUNT)
			set @LOOPCOUNT = @LOOPCOUNT + 1
			END;
---!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SET @DST =  '2021-03-31 09:00:00.000'
SET @NST =  '2021-03-31 21:00:00.000'
set @OUTERLOOP = @OUTERLOOP + 1
SET @LOOPCOUNT = 1

END;
---$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

END;

--EXEC [dbo].[CreateZoneEntryExitSim]
--SELECT * FROM AREACHANGES nolock
--DELETE FROM AREACHANGES