:: Format and Fill
:: v3.1
:: Revised by Wesley Brown
:: 08/13/10
::
:: Edited 03/11/13 by Chris Nash



:: driveexist - number of drives that were found
:: drivenum - current drive being parsed
:: drivelist - list of enumerated drives found, temp file that is removed
:: drivetype - type of drive that you want to create (1 - PC, 2 - MAC)
:: doublecheck - stores the answer for "are you sure" before creating the drives
:: nodrive_choice - stores the answer for whether you want to rescan for drives when none are found

@echo off

cls

setlocal enabledelayedexpansion
color 70


:: Header Information

echo.
echo.
echo ------------------------------------------------------------
echo Format and Fill v3.1
echo.
echo Create SWAT removal tools and software flash drives.
echo ------------------------------------------------------------
echo.
 


:: Check for available flash drives connected to the system

:drivescan

echo Scanning System for available flash drives.....
echo.
echo.
echo Displaying available drives:
echo.

set driveexist=0
if exist drivelist del drivelist
echo "">drivelist
echo "">drivename

FOR /F "usebackq tokens=1" %%a IN (`MOUNTVOL ^| FIND ":\"`) DO (
     set n=0
     FOR /F "usebackq tokens=3" %%b IN (`FSUTIL FSINFO DRIVETYPE %%a`) DO (                    
          IF /I "%%b" EQU "Removable" (
	       set "drives=!drives! %%a"
	       set /A driveexist+=1
               ECHO/|set /P="[ !driveexist! ]   %%a"
               FOR /F "usebackq tokens=4" %%l IN (`FSUTIL FSINFO VOLUMEINFO %%a`) DO (
                    IF !n! EQU 0 (
                         ECHO ^   %%l
			 echo %%a>>drivelist
			 echo %%l>>drivename
                         set n=1
                    )
               )
          )
     )
)

echo.
echo.



::No drives found connected

if !driveexist! EQU 0 (
     echo WARNING: No drives found!
     echo.

:rescan_choice
     set nodrive_choice=
     set /p nodrive_choice= "Would you like to rescan for available drives? [Y,N] "
     if exist drivelist (del drivelist)
     echo.
     echo.
     echo -----------------------------------------------------------------
     echo.
     if /i "!nodrive_choice!"=="Y" (goto drivescan)
     if /i "!nodrive_choice!"=="N" (goto end)
     echo Invalid option, please select [Y,N]
     echo.
     echo.
     goto rescan_choice
) 



:: Display the drive menu

:drivemenu

set drivenum=
set drive=
set drivelabel=
echo.
set /p drivenum=Choose the number of an available flash drive [1-%driveexist%]: 
if !drivenum! equ r goto drivescan
if !drivenum! lss 1 echo. & echo. & echo. & echo Invalid option. Please select the number of a drive. & goto drivemenu
if !drivenum! gtr !driveexist! echo. & echo. & echo. & echo Invalid option. Please select the number of a drive. & goto drivemenu
for /f "skip=%drivenum% tokens=*" %%r in (drivename) do set drivelabel=%%r
for /f "skip=%drivenum% tokens=1 delims=\" %%q in (drivelist) do set drive=%%q& goto choose_drivetype



:: Choose which type of drive to create

:choose_drivetype

cls
set driveexist=

echo.
echo.
echo Displaying the types of drives you can create:
echo.
echo.
echo [ 1 ]  SWAT_PC
echo [ 2 ]  SWAT_MAC
echo [ Q ]  I don't want to create a drive.......
echo.
echo.
echo.

:select_drivetype
set drivetype=
set /p drivetype=Select the type of drive would you like to create [1-2, Q]: 
if /i "!drivetype!"=="1" (goto swat_pc_setup)
if /i "!drivetype!"=="2" (goto swat_mac_setup)
if /i "!drivetype!"=="Q" (goto end)
echo.
echo.
echo.
echo Invalid option, please select [1-2, Q]
echo.
goto select_drivetype



:: Format and Fill Drives

:swat_pc_setup
cls 
set doublecheck=
set drivetype=SWAT_PC
echo.
echo.
echo You have selected the following options:
echo.
echo.
echo Drive you wish to Format and Fill:     !drive!\   !drivelabel!
echo You wish to create drive type:         !drivetype!
echo.
echo.

:pc_doublecheck
set /p doublecheck=Is this correct [Y,N]? 
if /i "!doublecheck!"=="Y" (goto pc_continue)
if /i "!doublecheck!"=="N" (cls & goto drivescan)
echo Invalid option, please select [Y,N]
echo.
goto pc_doublecheck

:pc_continue
cls
echo.
echo BEGINNING FORMAT AND FILL..........
echo -----------------------------------------------------------------
echo.
echo.
echo Formatting Drive %drive%
echo y | format %drive% /FS:FAT32 /V:SWAT_PC /Q
@echo on
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"Removal Tools" %drive%\"Removal Tools" /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"Utilities" %drive%\"Utilities" /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"Applications" %drive%\"Applications" /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"ePrint" %drive%\"ePrint" /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"32 Bit Service Packs"\"Vista SP1.exe" %drive%\"32 Bit Service Packs"\ /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"32 Bit Service Packs"\"Vista SP2.exe" %drive%\"32 Bit Service Packs"\ /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"32 Bit Service Packs"\"XP SP3.exe" %drive%\"32 Bit Service Packs"\ /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"32 Bit Service Packs"\"Win7 SP1.exe" %drive%\"32 Bit Service Packs"\ /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"64 Bit Service Packs" %drive%\"64 Bit Service Packs" /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"Office" %drive%\"Office" /E /F /I
xcopy /H C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\*.txt %drive%\
echo %TIME% on %DATE% > %drive%\LastUpdatedOn.txt
goto end

:swat_mac_setup
cls 
set doublecheck=
set drivetype=SWAT_MAC
echo You have selected the following options:
echo.
echo.
echo Drive you wish to Format and Fill:     !drive!\   !drivelabel!
echo You wish to create drive type:         !drivetype!
echo.
echo.

:mac_doublecheck
set /p doublecheck=Is this correct [Y,N]? 
if /i "!doublecheck!"=="Y" (goto mac_continue)
if /i "!doublecheck!"=="N" (cls & goto drivescan)
echo Invalid option, please select [Y,N]
echo.
goto mac_doublecheck

:mac_continue
cls
echo.
echo BEGINNING FORMAT AND FILL..........
echo -----------------------------------------------------------------
echo.
echo.
echo Formatting Drive %drive%
echo y | format %drive% /FS:FAT32 /V:SWAT_MAC /Q
@echo on
xcopy C:\"Documents and Settings"\"swat"\Desktop\"USB STUFF"\"Swat Thumbdrive"\"Mac Applications" %drive%\ /E /F /I

Echo %TIME% on %DATE% > %drive%\LastUpdatedOn.txt
goto end

:end
@echo off
echo.
echo.
echo -----------------------------------------------------------------
echo ENDING FORMAT AND FILL......
del drivelist
del drivename
color 07
