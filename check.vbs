Private Function GetFolder()
Dim objPath, objFolder, objFolderItem, objShell, strPath
  Const MY_COMPUTER = &H11&
  Const WINDOW_HANDLE = 0
  Const OPTIONS = 0
  objPath = ""
  Set objShell = CreateObject("Shell.Application")
  Set objFolder = objShell.Namespace(MY_COMPUTER)
  Set objFolderItem = objFolder.Self
  strPath = objFolderItem.Path  
  Set objFolder = objShell.BrowseForFolder(WINDOW_HANDLE, "Выберите папку-письмо: ", OPTIONS, strPath)   
  If Not objFolder Is Nothing Then
     Set objFolderItem = objFolder.Self
      objPath = objFolderItem.Path  
  End If
  GetFolder = objPath
End Function

Dim objShell
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "check.bat " & GetFolder()
