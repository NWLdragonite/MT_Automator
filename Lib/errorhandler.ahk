#Include <logger>

global ERR_MAX      := 3

global ERR_SUCCESS  := 0000
global ERR_RETRY    := 0001
global ERR_MAXRETRY := 0002
global ERR_IGNORE   := 0003

;===============================
; Load Scenario Error case
;===============================
global LOAD_SNR_ERR_FN                  := 0101 ; FileName Error 
global LOAD_SNR_ERR_DB_VER_NOT_MATCH    := 0102 ; DBase Version Does Not Match

;===============================
; Others
;===============================
global WINWAIT_DEFAULT_TIMEOUT := 2

errorhandler_BtnWait(BTN_classNN1, windowtitle1, windowtext1, WaitForObjClass1) {

    BlockInput, On

    loop {
        
        logger_Log("BtnWait : ControlClick - "BTN_classNN1)
    
        ControlClick, %BTN_classNN1%, %windowtitle1%, %windowtext1%
        
        logger_Log("BtnWait : WinWait - "WaitForObjClass1)
        WinWait, %WaitForObjClass1%, , WINWAIT_DEFAULT_TIMEOUT

        If (ErrorLevel = 0) {
            Break
        }
        Else
        {
            logger_Log("BtnWait : ErrorLevel - "ErrorLevel)
            retryCount++
            logger_Log("BtnWait : Retrying - "retryCount)
        }

        If (retryCount >= ERR_MAX){
            logger_Log("BtnWait : Exceeds Retry Limit - "retryCount)
            BlockInput, Off
            ExitApp, -1
        }

    }

    BlockInput, Off

}

errorhandler_BtnClick(ControlName, ControlText, ExpectedText, windowClassName, windowProcessID) {

    WinGetTitle, windowTitleName, %windowClassName% %windowProcessID%
    logger_log("Button Click: " . ControlName . " - " .  windowTitleName )
    retryCount := 0
    
    BlockInput, On
    ControlGetText, ButtonText, %ControlText% , %windowClassName% %windowProcessID%
    loop,
    {

        If (ButtonText = ExpectedText)
        {
            BlockInput, Off
            return ERR_SUCCESS
        }
        Else
        {
            ControlFocus, %ControlText% , %windowClassName% %windowProcessID%
            ControlClick, %ControlText% , %windowClassName% %windowProcessID%
            ControlGetText, ButtonText, %ControlName% , %windowClassName% %windowProcessID%

            retryCount++
            sleep WAIT_DEFAULT_TIMEOUT
        }

        If (retryCount = MAX_NO_OF_TRIES)
        {
            logger_log("Button Click: " . ControlName . " - " . windowTitleName . " Exceed retry limit."retryCount)
            BlockInput, Off
            ExitApp, -1
        }
    }

}

errorhandler_WinWait(WaitForObjClass1, Timeout:="") {

    Timeout := Timeout ? Timeout : WINWAIT_DEFAULT_TIMEOUT

    ; BlockInput, On

    loop {
        
        logger_Log("WinWait : WinWait - "WaitForObjClass1)
        WinWait, %WaitForObjClass1%, , %Timeout%

        If (ErrorLevel = 0) {
            Break
        }
        Else
        {
            logger_Log("WinWait : ErrorLevel - "ErrorLevel)
            retryCount++
            logger_Log("WinWait : Retrying - "retryCount)
        }

        If (retryCount >= ERR_MAX){
            logger_Log("WinWait : Exceeds Retry Limit - "retryCount)
            ; BlockInput, Off
            ExitApp, -1
        }

    }

    ; BlockInput, Off

}

errorhandler_WinWaitClose(WaitForObjClass1, Timeout:="") {

    Timeout := Timeout ? Timeout : WINWAIT_DEFAULT_TIMEOUT

    ; BlockInput, On

    loop {
        
        logger_Log("WinWaitClose : WinWaitClose - "WaitForObjClass1)
        WinWaitClose, %WaitForObjClass1%, , %Timeout%

        If (ErrorLevel = 0) {
            Break
        }
        Else
        {
            logger_Log("WinWaitClose : ErrorLevel - "ErrorLevel)
            retryCount++
            logger_Log("WinWaitClose : Retrying - "retryCount)
        }

        If (retryCount >= ERR_MAX){
            logger_Log("WinWaitClose : Exceeds Retry Limit - "retryCount)
            ; BlockInput, Off
            ExitApp, -1
        }

    }

    ; BlockInput, Off

}

errorhandler_LoadSnrErrorCheck(param1, param2) {

    If (param1 = LOAD_SNR_ERR_FN)
        return FileNameError(param2)    

    If (param1 = LOAD_SNR_ERR_DB_VER_NOT_MATCH)
        return DBVersionError()     

}




DBVersionError() {

    BlockInput, On

    WinWait, ahk_class TFM_YesNoDlg, ,WINWAIT_DEFAULT_TIMEOUT

    If (ErrorLevel = 0) {
        logger_Log("DB Version Does Not Match")
        ControlClick, TButton2

        BlockInput, Off
        return ERR_IGNORE
    }
    Else
    {
        logger_Log("Load Scenario Complete")

        BlockInput, Off
        return ERR_SUCCESS
    }

}

FileNameError(attemptCtr) {
    
    BlockInput, On

    logger_Log("FileName Error Check")

    Process Exist, SNL_EDIT.exe
    errPID = %ErrorLevel%

    IfWinExist, ahk_class #32770 ahk_pid %errPID% ahk_pid %errPID%
    {

        logger_Log("FileName Error Occur")

        ControlGetText, OutputVar , Static1, ahk_class #32770 ahk_pid %errPID%
        logger_Log(OutputVar)

        ControlClick, Button1, ahk_class #32770 ahk_pid %errPID%

        If (attemptCtr >= ERR_MAX) {
            logger_Log("Exceeds Max Retry")
            logger_Log("Attempt Count "attemptCtr)
            BlockInput, Off
            return ERR_MAXRETRY
        }

        BlockInput, Off
        return ERR_RETRY

    }
    
    
    logger_Log("No FileName Error")

    BlockInput, Off
    return ERR_SUCCESS
    
}
