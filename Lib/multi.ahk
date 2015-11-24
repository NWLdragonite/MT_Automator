multi_ParseParameters() {
    global 0
    global SNR_Array
    Loop, %0% ;
    {
        param := global %A_Index%
        SNR_Array[%A_Index%] := param
        ; MsgBox, 4,, Parameter number %A_Index% is %param%.  Continue?
        ; IfMsgBox, No
        ; break
        ; OSD(param)
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
        ; WinWaitClose, ahk_exe MaintenanceTool.exe
        Process, WaitClose, MaintenanceTool.exe
    }
}

multi_GetMainMenuHandle(index) {
    global MT_PATH
    path := MT_PATH . "MT" . index . "\exe\MT.INI"
    ; MsgBox, % path
    IniRead, handleVar, %path%, POST, Whandle
    ; MsgBox % handleVar
    return handleVar
}

multi_IsHandleValid(handle) {
    ; Process, Exist, %handle%
    ; Process, wait, ahk_id %handle%, 1
    ; NewPID = %ErrorLevel%
    ; msgbox % NewPID
    ; return NewPID
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
    ; MsgBox, % path
    IniRead, handleVar, %path%, STP_EXEC, STPWHANDLE
    ; MsgBox % handleVar
    return handleVar
}

multi_HasMainMenuHandle(index) {
    global MT_Array
    global MAIN_MENU
    ; if MT_Array[%index%]
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
    ; if MT_Array[%index%]
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
