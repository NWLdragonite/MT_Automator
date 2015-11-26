#Include <definitions>
#Include <multi>
#Include <exec>
#Include <loadsnr>
#Include <errorhandler>
#Include <MWErrorHandler>
#Include <config>

; SET TO 1 FOR SUBLIME RUN COMPATIBILITY
; SET TO 0 AND COMPILE FOR PARAMETERIZED INPUT VIA COMMANDLINE PARAMETERS
DEBUG_MODE:=0

#SingleInstance force
SetTitleMatchMode, RegEx
SetControlDelay -1 ; Set Control sending delay to as fast as possible

MaintenanceScreen() {
    errorhandler_WinWait("ahk_class TFM_MT_SELECT")
    errorhandler_BtnWait("TButton2", "ahk_class TFM_MT_SELECT", "All Start", "ahk_class TFM_ALLSTART")
    errorhandler_WinWaitClose("ahk_class TFM_ALLSTART", 20)
}

LoginScreen() {
    errorhandler_WinWait("ahk_class TFM_LOGIN")
    BlockInput, On
    ControlSend, TEdit1, nokia{Enter}{Enter}
    BlockInput, Off
}

ExecScreen() {
    errorhandler_WinWait("ahk_class TFM_RunMessage", 25)
    errorhandler_WinWaitClose("ahk_class TFM_RunMessage", 25)
    BlockInput, On
    ControlClick, TButton7, ahk_class TFM_MSEDIT
    BlockInput, Off
}

;===============================
; Autoexec start
;===============================
;Close first if running before changing the configuration file
multi_CloseIfRunning()

if !DEBUG_MODE {
    multi_ParseParameters()
    config_iniRead()
}

logger_Initialize()

Run %MTSELECT%, %MTSELECTPATH%

LoginScreen()

MaintenanceScreen()

logger_Log("AllStart Finished")
Loop, %MT_MAX%
{
    handle := multi_GetMainMenuHandle(A_Index)
    MT_Array[%A_Index%,%MAIN_MENU%] := handle ;works

    ;check if there is a saved handle
    if handle = 0
    {
        Continue
    }

    if !multi_IsHandleValid(handle) 
    {
        logger_Log("Handle is invalid: " . handle)
        Continue
    }

    logger_Log("====Start Processing for MT#" . A_Index . "====")
    logger_Log("Handle is valid: " . handle)

    ;Check if Execution Button is disabled
    ControlGet, OutputVar, Enabled, ,TBitBtn4, ahk_class TFM_MainMenu ahk_id %handle%
    while (OutputVar != 1)
    {
        ControlGet, OutputVar, Enabled, ,TBitBtn4, ahk_class TFM_MainMenu ahk_id %handle%
        Sleep, 10
    }
    ControlClick, TBitBtn4, ahk_id %handle%
    ExecScreen()
    if DEBUG_MODE 
    {
        loadsnr_LoadFile(SNRFILE)
    }
    Else
    {
        loadsnr_LoadFile(SNR_Array[%A_Index%])
    }

    snl_editHandle := multi_GetMacroExecHandle(A_Index)
    MT_Array[%A_Index%,%MACRO_EXEC%] := snl_editHandle
    exec_ScenarioExecution("ahk_id " . snl_editHandle)

    ; SaveMWError("TRichEdit1","ahk_class TFM_MSEDIT", MT_RESULT_LOG_PATH)

}

logger_log("====PREPARING FOR EXECUTION====")

Loop, %MT_MAX%
{
   
    ;check if there is a saved handle
    handle := MT_Array[%A_Index%,%MACRO_EXEC%]
    if handle = 0
    {
        Continue
    }

    if !multi_IsHandleValid(handle) 
    {
        multi_OSD("Handle is invalid")
        Continue
    }

    exec_ScenarioExecute("ahk_id " . handle)
    SaveMWError("TRichEdit1","ahk_class TFM_MSEDIT", MT_RESULT_LOG_PATH)
}


MT_Array:=""
SNR_Array:=""

multi_CloseIfRunning()
logger_Log("====MT_LOG_END====")

;===============================
; renaming of Log File start
;===============================

logger_Log("====START: Renaming of Log Files====")
loghandler_renameLogFiles()
logger_Log("====END: Renaming of Log Files====")