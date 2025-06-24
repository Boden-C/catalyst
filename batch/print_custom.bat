@echo off
setlocal enabledelayedexpansion

:: CONSTANTS
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
)

:: Function: print_custom
:: Usage: call :print_custom "message" [textColor] [backgroundColor] [prefixMessage] [prependTimestamp] [logToFile] [logToConsole] [logFile]
:print_custom
setlocal enabledelayedexpansion

:: Parse parameters with defaults
set "message=%~1"
set "textColor=%~2"
set "backgroundColor=%~3"
set "prefixMessage=%~4"
set "prependTimestamp=%~5"
set "logToFile=%~6"
set "logToConsole=%~7"
set "logFile=%~8"

:: Set defaults if parameters are empty
if "%textColor%"=="" set "textColor=white"
if "%backgroundColor%"=="" set "backgroundColor=black"
if "%prefixMessage%"=="" set "prefixMessage="
if "%prependTimestamp%"=="" set "prependTimestamp=false"
if "%logToFile%"=="" set "logToFile=false"
if "%logToConsole%"=="" set "logToConsole=true"
if "%logFile%"=="" (
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set "datePart=%%c-%%a-%%b"
    for /f "tokens=1-2 delims=: " %%a in ('time /t') do set "timePart=%%a-%%b"
    set "logFile=!datePart:~2!_!timePart!.log"
)

:: Define ANSI color codes
set "colors_fg_black=30"
set "colors_fg_red=31"
set "colors_fg_green=32"
set "colors_fg_yellow=33"
set "colors_fg_blue=34"
set "colors_fg_magenta=35"
set "colors_fg_cyan=36"
set "colors_fg_white=37"
set "colors_fg_bright_black=90"
set "colors_fg_bright_red=91"
set "colors_fg_bright_green=92"
set "colors_fg_bright_yellow=93"
set "colors_fg_bright_blue=94"
set "colors_fg_bright_magenta=95"
set "colors_fg_bright_cyan=96"
set "colors_fg_bright_white=97"

set "colors_bg_black=40"
set "colors_bg_red=41"
set "colors_bg_green=42"
set "colors_bg_yellow=43"
set "colors_bg_blue=44"
set "colors_bg_magenta=45"
set "colors_bg_cyan=46"
set "colors_bg_white=47"
set "colors_bg_bright_black=100"
set "colors_bg_bright_red=101"
set "colors_bg_bright_green=102"
set "colors_bg_bright_yellow=103"
set "colors_bg_bright_blue=104"
set "colors_bg_bright_magenta=105"
set "colors_bg_bright_cyan=106"
set "colors_bg_bright_white=107"

:: Get color codes
set "fgCode=!colors_fg_%textColor%!"
set "bgCode=!colors_bg_%backgroundColor%!"

:: Build timestamp if needed
set "timestamp="
if /i "%prependTimestamp%"=="true" (
    for /f "tokens=1-3 delims=:." %%a in ('echo %time%') do (
        set "hour=%%a"
        set "min=%%b"
        set "sec=%%c"
    )
    :: Pad with zeros
    if "!hour:~0,1!"==" " set "hour=0!hour:~1!"
    if "!min:~0,1!"==" " set "min=0!min:~1!"
    if "!sec:~0,1!"==" " set "sec=0!sec:~1!"
    set "timestamp=[!hour!:!min!:!sec!] "
)

:: Build full message
set "fullMessage=!timestamp!!prefixMessage!!message!"

:: Build colored output for console
set "coloredOutput=!ESC![!fgCode!;!bgCode!m!fullMessage!!ESC![0m"

:: Output to console
if /i "%logToConsole%"=="true" (
    echo !coloredOutput!
)

:: Output to file (without ANSI codes)
if /i "%logToFile%"=="true" (
    echo !fullMessage!>>"%logFile%"
)

endlocal
goto :eof

:: Example usage:
:: call :print_custom "Hello World" "green" "black" "[INFO] " "true" "true" "true" "mylog.log"
:: call :print_custom "Error message" "red" "black" "[ERROR] " "true" "false" "true"
:: call :print_custom "Simple message"
