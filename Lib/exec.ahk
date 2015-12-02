#Include <logger>
#Include <errorhandler>

global WAIT_DEFAULT_TIMEOUT := 2
global EXECUTION_TAB := 2
global MAX_NO_OF_TRIES := 3
global SUCCESS := 0
global FAILED := 1


; ===============================
; From "Edit Scenario" Tab 
; To "Execute Scenario" Tab
; preparing for scenario execution
; ===============================

exec_ScenarioExecution(mt_ProcessID) {

    WinGetTitle, TEST, ahk_class TFM_MSEDIT %mt_ProcessID%
    errorhandler_WinWaitClose("ahk_class TFM_SFR " . mt_ProcessID)

    logger_log("Changing to Execution Page...`n")

    BlockInput, On
    ControlFocus, TPageControl1, ahk_class TFM_MSEDIT %mt_ProcessID%
    ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT %mt_ProcessID%
    
    retryCount := 0
    loop,
    {
        If (OutputVar = EXECUTION_TAB)
        {
            logger_log("Successfully change to Execution Tab...")
            ; Return SUCCESS
            break
        }
        Else
        {

            logger_log("Sending (Ctrl+tab) to change active page.")
            ControlFocus, TPageControl1, %TEST% ahk_class TFM_MSEDIT %mt_ProcessID%
            ControlSend,TPageControl1, {CtrlDown}{Tab}{CtrlUp}, ahk_class TFM_MSEDIT %mt_ProcessID%
            ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT %mt_ProcessID%

            retryCount++
            sleep WAIT_DEFAULT_TIMEOUT
        }

        If (retryCount = MAX_NO_OF_TRIES)
        {
            logger_log("Exceed retry limit."retryCount)
            Return FAILED
            Break
        }
    }

    ;Enabling the Auto save button for saving logs
    ret_code := errorhandler_BtnClick("TButton20", "Auto Save on", "Auto Save off", "ahk_class TFM_MSEDIT", mt_ProcessID)
    if (ret_code = SUCCESS)
    {
        logger_log("Auto Save logs is Enabled.")
    }
    Else
    {
        logger_log("Auto Save logs is Disabled.")
        Return FAILED
    }

     Return SUCCESS   
}



;Click Scenario execute
exec_ScenarioExecute(mt_ProcessID) {

    WinActivate, ahk_class TFM_MSEDIT %mt_ProcessID%
    ControlFocus, TPageControl1, ahk_class TFM_MSEDIT %mt_ProcessID%

    ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT %mt_ProcessID%
    WinGetTitle, mt_Name, ahk_class TFM_MSEDIT %mt_ProcessID%
    logger_log("MT Title :  "mt_Name)
    logger_log("Process : "mt_ProcessID)

    if (OutputVar = EXECUTION_TAB)
    {
        ret_code := errorhandler_BtnClick("TButton5", "Scenario execute", "Terminate scenario", "ahk_class TFM_MSEDIT", mt_ProcessID)
    }

    if (ret_code = SUCCESS)
    {
        logger_log("Successfully clicked Scenario execute :"mt_Name)
    }
    Else
    {
        logger_log("Unsuccessfully clicked Scenario execute :"mt_Name)
    }
}

;Check for dependent scenarios
exec_checkDependencies(snr_name){
    if(snr_name = "cellsetup")
    {
        logger_log("Dependent scenario found.")
        loop
        {
            ControlGetText, OutputVar, TRichEdit1, HD-BDE Maintenance Tool [LTE Mode] MT#1
            srchstr1 = 1018 Inter eNB-CNT Message Receive Start
            srchstr2 = Reception result  0 Succeeded
            IfInString, OutputVar, %srchstr1%
            {
                IfInString, OutputVar, %srchstr2%
                {
                    logger_log("Executing Dependent scenario.")
                }
            }
            else
            {
                 Continue
            }
            Break
        }
    }
}