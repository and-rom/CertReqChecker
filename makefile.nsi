!include "${NSISDIR}\Contrib\EnvVarUpdate.nsh"

; Define application name
!define APPNAME "CertReqChecker"
!define APPNAMEANDVERSION " v. 0.6"

; Main Install settings
Name "${APPNAME} ${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\${APPNAME}"
OutFile "${APPNAME}Install.exe"

; Do not use compression
SetCompress off

Section ${APPNAME} install

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\"
	File "check.vbs"
	File "check.bat"
	File "check.py"
	File "oid.txt"

        CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\check.vbs"

	CreateDirectory "$SMPROGRAMS\${APPNAME}"
	CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "$INSTDIR\check.vbs"
	CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"

SectionEnd

Section -FinishSection
	
	${EnvVarUpdate} $0 "PATH" "P" "HKLM" "$INSTDIR"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

;Uninstall section
Section Uninstall

	; Delete Shortcuts
	Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
	Delete "$SMPROGRAMS\${APPNAME}\Uninstall.lnk"

	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	; Clean up
	Delete "$INSTDIR\check.vbs"
	Delete "$INSTDIR\check.bat"
	Delete "$INSTDIR\check.py"
	Delete "$INSTDIR\oid.txt"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\${APPNAME}"
	RMDir "$INSTDIR\"
	
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
	
SectionEnd

; eof
