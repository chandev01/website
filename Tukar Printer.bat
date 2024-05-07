@echo off

SET title=%~n0
TITLE %title% 1.0
      for /f "tokens=5,6 delims=. " %%i in ('ver') do ( 
       set VERSION=%%i.%%j
        )

       if "%version%" == "5.1" ( 

       echo This batch file not working in WinXP!
       pause
       goto C
       
       )

:MENU

CLS
echo LIST OF PRINTERS ON LPT PORT           
echo ========================================

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
	   
	   
	    
       
    For /l %%c in (1 1 %printerCnt%) do  echo [%%c] - !printer%%c!
    
 
    echo.
    REM echo Hit ENTER to skip/quit    
        ECHO Enter a printer number:
        
        set selection=
        set /p "selection=DISABLE PRINTER: "
        set "NewPrinter=!printer%selection%!"
        
        if [!NewPrinter!]==[] (goto H)
        
        RUNDLL32 PRINTUI.DLL,PrintUIEntry /Xs /n "%NewPrinter%" PortName "LPT2:" 
        
        
        :H
        
        set selection=
        set /p "selection=ENABLE PRINTER: "
        set "NewPrinter=!printer%selection%!"
		
       if [!NewPrinter!]==[] (goto I)
        
        RUNDLL32 PRINTUI.DLL,PrintUIEntry /Xs /n "%NewPrinter%" PortName "LPT1:" 
        
        :I
        CLS
		
		set printerCntt=0
		For /f "tokens=2* delims==" %%y in (
        'wmic printer where "PortName like '%%LPT1%%'" get name /format:value'
		) do ( 
			set /a printerCntt+=1
		)
		
		CLS
		if %printerCntt% EQU 0 (
		ECHO =========================================
		echo %printerCntt% PRINTER on LPT 1 Port
		ECHO =========================================
		ECHO.
		
		CHOICE /C YN /M "Try Again?"
        IF ERRORLEVEL 2 GOTO C
        IF ERRORLEVEL 1 GOTO MENU
		
		)
		
		if %printerCntt% GEQ 2 (
		ECHO =========================================
		echo %printerCntt% PRINTER on LPT 1 Port
		ECHO =========================================
		ECHO.
		
		CHOICE /C YN /M "Try Again?"
        IF ERRORLEVEL 2 GOTO C
        IF ERRORLEVEL 1 GOTO MENU
		
		) 
		
		if %printerCntt% EQU 1 (
		
		
		echo ENABLE PRINTER
		ECHO -----------------------------------------
		wmic printer get name, portname | findstr /i "LPT1"
		
		ECHO.
		pause
		
		)

:C
    exit
     
 
    



        
        
      
    
    



