@ECHO OFF

chcp 1251 > nul 
set msg1=������� ���� � �����-������: 
set msg2=������������� �������...
set msg3=������ python �������
set msg4=����������

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
