#Include <definitions>
#Include <errorhandler>
#Include <loadsnr>

screen_Maintenance() {
    errorhandler_WinWait("ahk_class TFM_MT_SELECT")
    errorhandler_BtnWait("TButton2", "ahk_class TFM_MT_SELECT", "All Start", "ahk_class TFM_ALLSTART")
    errorhandler_WinWaitClose("ahk_class TFM_ALLSTART", 20)
}

screen_Login() {
    errorhandler_WinWait("ahk_class TFM_LOGIN")
    BlockInput, On
    ControlSend, TEdit1, nokia{Enter}{Enter}
    BlockInput, Off
}

screen_Exec() {
    errorhandler_WinWait("ahk_class TFM_RunMessage", 25)
    errorhandler_WinWaitClose("ahk_class TFM_RunMessage", 25)
    BlockInput, On
    ControlClick, TButton7, ahk_class TFM_MSEDIT
    BlockInput, Off
}


screen_Startup() {
    ;Close first if running before changing the configuration file
    multi_CloseIfRunning()
    multi_ParseParameters()
    config_iniRead()
    logger_Initialize()
}

screen_PushExecButton(handle) {
    ;Check if Execution Button is disabled
    ControlGet, OutputVar, Enabled, ,TBitBtn4, ahk_class TFM_MainMenu ahk_id %handle%
    while (OutputVar != 1)
    {
        ControlGet, OutputVar, Enabled, ,TBitBtn4, ahk_class TFM_MainMenu ahk_id %handle%
        Sleep, 10
    }
    BlockInput, On
    ControlClick, TBitBtn4, ahk_id %handle%
    BlockInput, Off
}

screen_LoadScenario(file) {
    loadsnr_LoadFile(file)
}

screen_ScenarioExec(index) {
    global MACRO_EXEC
    global MT_Array

    snl_editHandle := multi_GetMacroExecHandle(index)
    MT_Array[%index%,%MACRO_EXEC%] := snl_editHandle
    exec_ScenarioExecution("ahk_id " . snl_editHandle)
}


screen_GetMtHandle(index) {
    global MT_Array
    global MAIN_MENU 

    handle := multi_GetMainMenuHandle(index)
    MT_Array[%index%,%MAIN_MENU%] := handle ;works

    if !screen_IsHandleExisting(handle)
    {
        return handle

    }

    logger_Log("====Start Processing for MT#" . index . "====")
    logger_Log("Handle is valid: " . handle)
    return handle
}

screen_ScenarioExecStart(index) {
    global MT_Array
    global MACRO_EXEC

    ;check if there is a saved handle
    handle := MT_Array[%index%,%MACRO_EXEC%]
    if !screen_IsHandleExisting(handle)
    {
        return handle

    }
}

screen_IsHandleExisting(handle) {

    if handle = 0
    {
        return handle
    }

    if !multi_IsHandleValid(handle) 
    {
        logger_Log("Handle is invalid: " . handle)
        logger_Log("MT setup may be corrupted")
        ExitApp 
    }
}

screen_ErrorLogs() {
   global MT_RESULT_LOG_PATH 

    SaveMWError("TRichEdit1","ahk_class TFM_MSEDIT", MT_RESULT_LOG_PATH)
}

screen_Cleanup() {
   global MT_Array
   global SNR_Array
    
   MT_Array:=""
   SNR_Array:=""

   multi_CloseIfRunning()
   logger_Log("====MT_LOG_END====")

   ;===============================
   ; renaming of Log File start
   ;===============================

   logger_Log("====START: Renaming of Log Files====")
   loghandler_renamer()
   logger_Log("====END: Renaming of Log Files====")
}