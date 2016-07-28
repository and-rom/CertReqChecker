@ECHO OFF

chcp 1251 > nul 
set msg1=Введите путь к папке-письму: 
set msg2=Обрабатывются запросы...
set msg3=Запуск python скрипта
set msg4=Завершение

chcp 866 > nul 

SET batpath=%~dp0

:loop
IF "%1"=="" SET /p runpath=%msg1%
IF NOT "%1"=="" SET runpath=%1


IF NOT EXIST %runpath%\asn MKDIR %runpath%\asn

ECHO %msg2%
FOR /R %runpath%\req\ %%f in (*.req) DO (

  IF NOT EXIST %runpath%\asn\%%~nf.txt certutil -asn %%f > %runpath%\asn\%%~nf.txt
)

ECHO %msg3%
python "%batpath%\check.py" %runpath%

ECHO %msg4%
pause
ECHO.
goto loop
