; Stress test for execute scenario
#Include <definitions>
#Include <screen>
#Include <multi>
#Include <exec>
#Include <loadsnr>
#Include <errorhandler>
#Include <MWErrorHandler>
#Include <config>

#SingleInstance force
SetTitleMatchMode, RegEx
SetControlDelay -1

global MT_MAX
global MT_Array
global MACRO_EXEC

global ERR_SUCCESS


global SCENARIONAME := "cellsetup"
Delay := 50

;===============================
; Autoexec start
;===============================
multi_CloseIfRunning()    
config_iniRead()
logger_Initialize()
Run %MTSELECT%, %MTSELECTPATH%
screen_Login()
screen_Maintenance()
logger_Log("AllStart Finished")

Loop, %MT_MAX%
{

    handle := screen_GetMtHandle(A_Index)
    if handle = 0
    {
        Continue
    }
    screen_PushExecButton(handle)
    screen_Exec()
    screen_LoadScenario(SNR_Array[%A_Index%])

    successCount := 0
    failedCount := 0
    index = %A_Index%

    loop, 100
    {
        Sleep, Delay
        screen_ScenarioExec(index)
        snl_editHandle := MT_Array[%index%,%MACRO_EXEC%]
       
        Sleep, Delay
        BlockInput, On
        ControlGetText, VarB, Auto Save.*, ahk_class TFM_MSEDIT ahk_id %snl_editHandle%
        BlockInput, Off
 
        Sleep, Delay
        Return_Code := BackToPreviousState("ahk_id " . snl_editHandle)
 
        Sleep, Delay
        BlockInput, On
        ControlGetText, VarC, Auto Save.*, ahk_class TFM_MSEDIT ahk_id %snl_editHandle%
        BlockInput, Off

        if( VarB = "Auto Save off" && Return_Code = ERR_SUCCESS)
        {
            successCount++  
        }
        Else
        {
            failedCount++
        }

        logger_log("======Test #"A_Index)
    
    }

    logger_log("========Pass Test : "successCount)
    logger_log("========Fail Test : "failedCount)
}
logger_log("--------DONE-----------")

BackToPreviousState(mtProccessID){

    BlockInput, On
    ret_code := errorhandler_BtnClick("TButton20", "Auto Save off", "Auto Save on", "ahk_class TFM_MSEDIT", mtProccessID)
    BlockInput, Off

    BlockInput, On
    ControlFocus, TPageControl1, ahk_class TFM_MSEDIT %mtProccessID%
    ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT %mtProccessID%
    BlockInput, Off

    While !(OutputVar = 1)
    {
        Sleep, 5
        BlockInput, On
        ControlFocus, TPageControl1, ahk_class TFM_MSEDIT %mtProccessID%
        ControlSend,TPageControl1, {CtrlDown}{Tab}{CtrlUp}, ahk_class TFM_MSEDIT %mtProccessID%
        ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT %mtProccessID%
        BlockInput, Off
    }
    if (ret_code = ERR_SUCCESS && OutputVar =1)
    {
        Return ERR_SUCCESS
    }
    Else{
        Return 0001
    }
}
