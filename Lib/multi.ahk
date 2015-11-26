#Include <screen>

multi_ParseParameters() {
    global 0

    if 0 > 1
    {
        logger_Log("Too many parameters, use only 1")
        ExitApp
    }

    Loop %0%
    {
        global SCENARIONAME 
        SCENARIONAME := global %A_Index%
        Break
    }
}

multi_CloseIfRunning() {
    IfWinExist, ahk_exe MaintenanceTool.exe
    {
        WinClose,
        WinWait, ahk_class TMessageForm
        {
            BlockInput, On
            ControlClick, TButton2
            BlockInput, Off
        }
        Process, WaitClose, MaintenanceTool.exe
    }
}

multi_GetMainMenuHandle(index) {
    global MT_PATH

    path := MT_PATH . "MT" . index . "\exe\MT.INI"
    IniRead, handleVar, %path%, POST, Whandle
    return handleVar
}

multi_IsHandleValid(handle) {

    if WinExist("ahk_id" . handle)
    {
        return True
    }
    Else
    {
        return False
    }
}

multi_GetMacroExecHandle(index) {
    global MT_PATH

    path := MT_PATH . "MT" . index . "\exe\MT.INI"
    IniRead, handleVar, %path%, STP_EXEC, STPWHANDLE
    return handleVar
}

multi_HasMainMenuHandle(index) {
    global MT_Array
    global MAIN_MENU

    if MT_Array[%index%][%MAIN_MENU%]
    {
        return true
    }
    Else
    {
        Return false
    }
}

multi_HasMacroExecHandle(index) {
    global MT_Array
    global MAIN_MENU
    global MACRO_EXEC

    if MT_Array[%index%][%MACRO_EXEC%]
    {
        return true
    }
    Else
    {
        Return false
    }
}

multi_OSD(msg) {
    global DEBUG_MODE
    
    if DEBUG_MODE 
    {
        SplashTextOn,,, % msg
        Sleep 1000
        SplashTextOff
    }
    Return
}

multi_MTstartupOk(index) {

    handle := multi_GetMainMenuHandle(index)
    MT_Array[%index%,%MAIN_MENU%] := handle ;works

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

    logger_Log("====Start Processing for MT#" . index . "====")
    logger_Log("Handle is valid: " . handle)
    ; screen_PushExecButton(handle)
    return handle

}