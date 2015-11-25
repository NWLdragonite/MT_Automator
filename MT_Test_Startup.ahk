#Include <definitions>
#Include <multi>
#Include <exec>
#Include <loadsnr>
#Include <errorhandler>
#Include <MWErrorHandler>

; SET TO 1 FOR SUBLIME RUN COMPATIBILITY
; SET TO 0 AND COMPILE FOR PARAMETERIZED INPUT VIA COMMANDLINE PARAMETERS
DEBUG_MODE:=1

#SingleInstance force
SetTitleMatchMode, RegEx
SetControlDelay -1 ; Set Control sending delay to as fast as possible

MaintenanceScreen() {
    errorhandler_WinWait("ahk_class TFM_MT_SELECT")
    errorhandler_BtnWait("TButton2", "ahk_class TFM_MT_SELECT", "All Start", "ahk_class TFM_ALLSTART")
    errorhandler_WinWaitClose("ahk_class TFM_ALLSTART",20)
}

LoginScreen() {
    errorhandler_WinWait("ahk_class TFM_LOGIN")
    BlockInput, On
    ControlSend, TEdit1, nokia{Enter}{Enter}
    BlockInput, Off
}

ExecScreen() {
    errorhandler_WinWait("ahk_class TFM_RunMessage",20)
    errorhandler_WinWaitClose("ahk_class TFM_RunMessage",20)
    BlockInput, On
    ControlClick, TButton7, ahk_class TFM_MSEDIT
    BlockInput, Off
}

;===============================
; Autoexec start
;===============================

if !DEBUG_MODE {

    multi_ParseParameters()
}

i := 1
logger_Initialize()
Loop, 100
{        
    ;MsgBox, %name%
    multi_CloseIfRunning()
    logger_Log("=====MT Automation Startup test :" . i . "======")
    Loop, %MT_MAX%
    {
        global MT_PATH
        path := MT_PATH . "MT" . A_Index . "\USER\*.mlog"
        FileDelete, %path%
    }
    
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
    }
    logger_log("======= Test " . i . " success ======-")
    i++
}
multi_CloseIfRunning()
