@echo off
::=============================
:: TESTING 123456789
REM ENVIRONMENT: W7 32bit
REM STRAT DATE:5 JAN 2022
::=============================

SET title=%~n0
TITLE %title% 1.3
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
    goto MENU
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
echo. 2. Exchange Printer Port (LPT1/LPT2)
echo. 3. Change Default Printer (LOCAL)
echo. 4. Create MAIN Shorcut Link (C/F)
echo. 5. Restart Explorer
echo. 6. Advanced



echo:
echo =Press [Q] to quit==============
echo. 

CHOICE /C 123456Q /n /M "ENTER YOUR CHOICE:"
:: /t 30

IF ERRORLEVEL 7 GOTO C
IF ERRORLEVEL 6 GOTO ver
IF ERRORLEVEL 5 GOTO Q
IF ERRORLEVEL 4 GOTO E
IF ERRORLEVEL 3 GOTO Lbl3
IF ERRORLEVEL 2 GOTO F
IF ERRORLEVEL 1 GOTO A

:A
    CLS
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
        IF ERRORLEVEL 2 GOTO A
        IF ERRORLEVEL 1 GOTO MENU
        )
        
      
		
        ping -n 1 -4 "%Newserver%" | find "TTL=" >nul 
        if errorlevel 1 ( 
        CLS
        echo =========================
        echo     CONNECTION FAILED 
        echo =========================
        timeout /t 3
        goto Menu
        
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
		CHOICE /C YN /M "Do you want open Disk Management ?
		IF ERRORLEVEL 2 GOTO MENU
        IF ERRORLEVEL 1 GOTO N
        goto MENU
		
        )
    )
        
        
    
    

    goto MENU



    
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
				IF ERRORLEVEL 2 GOTO MENU
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
		goto menu
		
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
    CHOICE /C YN /M "Do you want create MAIN shorcut on Desktop?"
        IF ERRORLEVEL 2 GOTO C
        IF ERRORLEVEL 1 GOTO L
    

    ) else (

    echo ---------------------
    echo MAIN already exists.
    echo Do you want recreate and remove all MAIN shortcut on Desktop?
    CHOICE /C YN /M "Yes/No"
        IF ERRORLEVEL 2 GOTO C
        IF ERRORLEVEL 1 GOTO K

    )
    
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
    

    timeout /t 3
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


:D
echo hi
    
:E
    CLS
    echo ----------------------------------------------
    echo Before create a MAIN shortcut, 
    echo Make sure the NETWORK DRIVE mapping correctly!
    echo ----------------------------------------------
    echo C: Add MAIN shortcut link to the drive C
    echo F: Add MAIN shortcut link to the drive F
    echo Q: Back to menu.
    echo:
    CHOICE /C CFQ /M "ENTER YOUR CHOICE:"
    IF ERRORLEVEL 3 GOTO MENU
    IF ERRORLEVEL 2 GOTO CLS2
    IF ERRORLEVEL 1 GOTO CSL
    
    pause
    
    
    :CSL
    set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"

    echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
    echo sLinkFile = "%USERPROFILE%\Desktop\MAIN.lnk" >> %SCRIPT%
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
    echo oLink.TargetPath = "F:\DA51\MAIN.bat" >> %SCRIPT%
    echo oLink.WorkingDirectory = "F:\DA51" >> %SCRIPT%
    echo oLink.Save >> %SCRIPT%

    cscript /nologo %SCRIPT%
    del %SCRIPT%
    
    echo -------------------------------------------
    echo Please check your shortcut MAIN on desktop!
    echo -------------------------------------------
    
    pause
    goto MENU
    
    :CSL2
    set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"

    echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
    echo sLinkFile = "%USERPROFILE%\Desktop\MAIN.lnk" >> %SCRIPT%
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
    echo oLink.TargetPath = "C:\DA51\MAIN.bat" >> %SCRIPT%
    echo oLink.WorkingDirectory = "C:\DA51" >> %SCRIPT%
    echo oLink.Save >> %SCRIPT%

    cscript /nologo %SCRIPT%
    del %SCRIPT%
    
    echo -------------------------------------------
    echo Please check your shortcut MAIN on desktop!
    echo -------------------------------------------
    
    pause
    goto MENU

    
    :Lbl1

    notepad /p print.txt
 
    
    :Lbl2
 
    write.exe config.ini
	CLS
	echo --------------------------------------------------------------------- 
	echo [Description],[Computer Name/IP Address],[Share Name],[Driver Letter]
	echo ---------------------------------------------------------------------	
	pause
    goto MENU

    :Lbl3
    CLS
    
    FOR /F "tokens=2* delims==" %%B in (
    'wmic printer where "default=True" get name /value'
    ) do SET DefaultPrinter=%%B
    echo -------------------------------------------
    echo DEFAULT PRINTER: %DefaultPrinter%
    echo ------------------------------------------- 
    echo -------------------------------------------
    echo LIST OF PRINTER
    echo -------------------------------------------
    setlocal EnableDelayedExpansion
    set printerCnt=0
    For /f "skip=1 delims=" %%a in (
        'wmic printer where "local=TRUE" get name /format:value'
    ) do ( 
        
        for /f "tokens=2* delims==" %%# in (
        "%%a"
        ) do ( 
        
        for /f "delims=" %%b in ("%%#") do (
         set /a printerCnt+=1                
           set "printer!printerCnt!=%%b"
           
           )
    )
       )
       
       For /l %%c in (1 1 %printerCnt%) do echo    [%%c] - [!printer%%c!] 
    echo Hit ENTER to quit
        set selection=
        set /p "selection=Enter a printer number: "
        set "NewPrinter=!printer%selection%!"
        
        if [!NewPrinter!]==[] ( goto menu )
        
       
       

        echo. Printer selected: [%NewPrinter%]
        RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n "!NewPrinter!"
        timeout /t 5
            
        CHOICE /C YN /M "Back to Menu?"
        IF ERRORLEVEL 2 GOTO Lbl3
        IF ERRORLEVEL 1 GOTO MENU

      
    
    
:F
:: wmic printer get name,shared,servername,SystemName,ShareName,PortName,network,local >> test.txt
CLS
echo PRINTER NAME                   PORT 
echo=======================================
wmic printer get name, portname | findstr /i "LPT"
echo ---------------------------------------  
setlocal EnableDelayedExpansion
    
    set printerCnt=0
    For /f "tokens=* delims=" %%a in (
        'wmic printer where "PortName like '%%LPT%%'" get name /format:value'
    ) do ( 
        
        for /f "tokens=2* delims==" %%# in (
        "%%a"
        ) do (
        
        
        for /f "delims=" %%b in ("%%#") do (
         set /a printerCnt+=1                
           set "printer!printerCnt!=%%b"
        )   
           
    )
       )
       
    For /l %%c in (1 1 %printerCnt%) do  echo [%%c] - [!printer%%c!] 
    
 
    echo.
    echo Hit ENTER to skip/quit    
        
        
        set selection=
        set /p "selection=Change LPT2, Enter a printer number: "
        set "NewPrinter=!printer%selection%!"
        
        if [!NewPrinter!]==[] (goto H)
        
        RUNDLL32 PRINTUI.DLL,PrintUIEntry /Xs /n "%NewPrinter%" PortName "LPT2:" 
        
        
        :H
        
        set selection=
        set /p "selection=Change LPT1, Enter a printer number: "
        set "NewPrinter=!printer%selection%!"
        
       if [!NewPrinter!]==[] (goto I)
        
        RUNDLL32 PRINTUI.DLL,PrintUIEntry /Xs /n "%NewPrinter%" PortName "LPT1:" 
        
        :I
        
        CHOICE /C YN /M "Back to Menu?"
        IF ERRORLEVEL 2 GOTO F
        IF ERRORLEVEL 1 GOTO MENU
        
        
        
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
		goto menu
		)
		
		:N
		start diskmgmt
		goto MENU
		
    
		:O
		
		rmdir /s /q c:\DA51
		
		goto M
		
		:Q
		taskkill /im explorer.exe /f
		start explorer.exe
		goto MENU
    
    
:ver
CLS
setlocal enableDelayedExpansion

	set userinput=
	set /p userinput=Enter Your Password:
	set "plaintext=%userinput%"
	set "file=%temp%\%~n0.tmp"
	set md=


	if not defined plaintext set /P "plaintext="

	if exist "%plaintext%" (
		
		set "file=%plaintext%"

	) else for %%I in ("%file%") do if %%~zI equ 0 (
		
		<NUL >"%file%" set /P "=%plaintext%"
	
	)

	for /f "skip=1 delims=" %%I in (
	'certutil -hashfile "%file%" MD5'
	) do (
    
		if not defined md set "md=%%I"
	
	)

	2>NUL del "%temp%\%~n0.tmp"

	echo %md: =% >>code.txt
	set /p h1=<code.txt
	ping localhost -n 2 >nul
	del code.txt
	
	for /f "skip=1" %%a in (
		cfg.exe
	) do (
	
		if not defined line set "h2=%%a"
		 
		
	)
	
	
	if %h1% equ %h2% ( 
		goto SUBMAIN
	) else ( 
		goto  error 
	)
	
:error

echo =========================
echo   Incorrect Password
echo =========================
pause
goto ver


:SUBMAIN
CLS
echo  UTILITY TOOLS            Page 2
echo ================================
echo. 1. Edit config


echo:
echo =Press [Q] to quit==============
echo. 

CHOICE /C 1Q /n /M "ENTER YOUR CHOICE:"


IF ERRORLEVEL 2 GOTO C
IF ERRORLEVEL 1 GOTO lbl2

