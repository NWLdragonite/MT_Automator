MT_PATH:="C:\BS3201_Tools\HDBDE_MT\"
SNRFILE := A_ScriptDir . "\" . "1CallMAX6Cell_CP_1.snr"
MTSELECT := "C:\BS3201_Tools\HDBDE_MT\exe\MaintenanceTool.exe"
MTSELECTPATH := "C:\BS3201_Tools\HDBDE_MT\exe\"
MT_MAX:=32
MAIN_MENU:=1
MACRO_EXEC:=2
MT_Array:=[]
MT_Array[1]:=[]
SNR_Array:=[]
WS_DISABLED:=0x8000000
MT_AUTO_LOG_PATH:=A_ScriptDir . "\" . "MT_AUTO_LOG.TXT"
MT_RESULT_LOG_PATH:=A_ScriptDir . "\" . "EXECUTION_LOG.TXT"

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
 ; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.