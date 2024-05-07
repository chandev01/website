@echo off
::=============================
:: TESTING
REM ENVIRONMENT: W7 32bit
REM STRAT DATE:5 JAN 2022
::=============================

SET title=%~n0
TITLE %title% 1.5 BY JOHN YONG
REM mode con:cols=100 lines=60


       
       for /f "tokens=5,6 delims=. " %%i in ('ver') do ( 
       set VERSION=%%i.%%j
        )

       if "%version%" == "5.1" ( 

       echo This batch file not working in WinXP!
       pause
       goto C
       
       )
       
          
       
    CLS
    
    set var="%~dp0"
    set bar="%userprofile%\Desktop\"

    if %var% EQU %bar% ( 
    goto A
    ) else (
    echo Please put batch file on desktop!
    pause
    goto c
    )
    
:MENU

CLS
echo  UTILITY TOOLS	  
echo ================================
echo. 1. Map/Change Server
echo. 2. Restart Explorer




echo:
echo =Press [Q] to quit==============
echo. 

CHOICE /C 12Q /n /M "ENTER YOUR CHOICE:"
:: /t 30


IF ERRORLEVEL 3 GOTO C
IF ERRORLEVEL 2 GOTO Q
IF ERRORLEVEL 1 GOTO A

:A
    CLS
	echo ================================
	echo    CHANGE SERVER
	echo ================================
    echo ------------------------
    echo    No.   Server Name 
    echo ------------------------
    setlocal EnableDelayedExpansion
    set serverCnt=0
    For /f "tokens=*" %%1 in (
        config.ini
    ) do ( 
    for /f "tokens=1,2,3,4,5 delims=," %%2 in ("%%1") do (
         set /a serverCnt+=1    
		 set "servertitle!serverCnt!=%%2"		 
         set "server!serverCnt!=%%3"
         set "fname!serverCnt!=%%4"
		 set "dname!serverCnt!=%%5"

          
    )
       )
	   
             
        For /l %%a in (1 1 %serverCnt%) do echo    [%%a] - [!servertitle%%a!]
        echo:
        echo Hit ENTER to quit
        set selection=
        set /p "selection=Enter a server number: "
        set "Newserver=!server%selection%!"
        set "Newpath=!fname%selection%!"
		set "Newdrive=!dname%selection%!"
        
        IF [!Newserver!]==[] ( 
        echo Invalid Number
        echo:
        CHOICE /C YN /M "Back to Menu?"
        IF ERRORLEVEL 2 GOTO C
        IF ERRORLEVEL 1 GOTO MENU
        )
        
      
		
        ping -n 1 -4 "%Newserver%" | find "TTL=" >nul 
        if errorlevel 1 ( 
        CLS
        echo =========================
        echo     CONNECTION FAILED 
        echo =========================
        timeout /t 3
        goto A
        
        ) else (
        wmic logicaldisk get name, drivetype | findstr /v  "4" | findstr /i  "F"
        if errorlevel 1 (
        
        net use F: /delete
        net use F: \\!Newserver!\!Newpath!
        goto P
        		      
        ) else (
		
        cls
        echo =========================
        echo  F DRIVE ALREADY IN USE
        echo =========================
        timeout /t 3
		
        goto A
		
        )
    )
        
        
    
    

    goto A



    
:C
    exit
    
:P

		pushd F:\Da51\
	if exist F:\Da51\MAIN.BAT (
		popd
			
		if /I !NewDrive!==c (
		
			if not exist c:\Da51\ (
				CLS
				CHOICE /C YN /M "Do you want copy DA51 into DRIVE %NewDrive% ?
				IF ERRORLEVEL 2 GOTO C
				IF ERRORLEVEL 1 GOTO M
			
			) else (
		
				CLS	
				CHOICE /C YN /M "Do you want Replace DA51 into DRIVE %NewDrive% ?
				IF ERRORLEVEL 2 GOTO J
				IF ERRORLEVEL 1 GOTO O
		
		
		
			)
	
		) 
	
	goto J
	
	) else (
	
	
		CLS
        echo =========================
        echo  FILE/FOLDER IS MISSING!
        echo =========================
		echo.
		timeout /t 3
		goto A
		
	)


   

:J
    CLS
    setlocal EnableDelayedExpansion
    echo ==========================
    echo LIST OF SHORTCUT
    echo ==========================
    set "SearchString=MAIN"
    for /f "delims=" %%i in (
        'dir /b  /a-d ^| findstr  /b "%SearchString%" ^| findstr  /e "lnk"'
    ) do (

            set var=%%i
            set var1=!var!
            echo %%~i

        )


    if [!var1!]==[]  (  
    CLS
    REM CHOICE /C YN /M "Do you want create MAIN shorcut on Desktop?"
        REM IF ERRORLEVEL 2 GOTO C
        REM IF ERRORLEVEL 1 GOTO L
    goto L

    ) else (
	
	echo -------------------------------------------
    echo READY TO LUNCH MAIN
    echo -------------------------------------------
    
 
    timeout /t 1 >nul
    start "" "!var1!"
	REM start main.ink
	IF ERRORLEVEL 1 goto V
	
    goto c

    

    )
    
	:V
	echo.
	echo ---------------------
    echo MAIN IS MISSING/INCORRECT NAME.
    echo Do you want recreate and remove all MAIN shortcut on Desktop?
    CHOICE /C YN /M "Yes/No"
        IF ERRORLEVEL 2 GOTO C
        IF ERRORLEVEL 1 GOTO K
	
    :L
    set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"

    echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
    echo sLinkFile = "%USERPROFILE%\Desktop\MAIN.lnk" >> %SCRIPT%
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
    echo oLink.TargetPath = "%Newdrive%:\DA51\MAIN.bat" >> %SCRIPT%
    echo oLink.WorkingDirectory = "%Newdrive%:\DA51" >> %SCRIPT%
    echo oLink.Save >> %SCRIPT%

    cscript /nologo %SCRIPT%
    del %SCRIPT%
    
    echo -------------------------------------------
    echo READY TO LUNCH MAIN
    echo -------------------------------------------
    

    timeout /t 2
    start MAIN.lnk
    goto c
    
    :K
    set "SS=MAIN"
    for /f "delims=" %%g in (
        'dir /b  /a-d ^| findstr  /b "%SS%" ^| findstr  /e "lnk"'
    ) do (
        echo %%~g
        del "%%~g"
        REM del /p "%%~g"
    
    )
    goto L


        
        :I
        
        CHOICE /C YN /M "Back to Menu?"
        IF ERRORLEVEL 2 GOTO F
        IF ERRORLEVEL 1 GOTO A
        
        
        
        :M
       
		set source="f:\DA51"
		set destination="c:\DA51"
		
		pushd %source%
		if exist %source%\MAIN.BAT (
		popd
		robocopy %source% %destination%  /E /IS /tee /log:log.txt
		timeout /t 3
		goto J
		
		) else (
		
		CLS
		echo =========================
        echo  FILE/FOLDER IS MISSING!
        echo =========================
		timeout /t 3
		goto A
		)
		
		:N
		start diskmgmt
		goto A
		
    
		:O
		
		rmdir /s /q c:\DA51
		
		goto M
		
		:Q
		taskkill /im explorer.exe /f
		start explorer.exe
		goto MENU
		

