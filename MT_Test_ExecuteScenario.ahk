; Stress test for execute scenario

#Include <definitions>
#Include <multi>
#Include <exec>
#Include <errorhandler>

global MT_MAX
global MT_Array
DELAY := 10
logger_log("------------start---------")

loop, %MT_MAX%
{

    snl_editHandle := multi_GetMacroExecHandle(A_Index)
    MT_Array[%A_Index%,%MACRO_EXEC%] := snl_editHandle

    if snl_editHandle = 0
    {
        Continue
    }

    if !multi_IsHandleValid(snl_editHandle) 
    {
        multi_OSD("Handle is invalid")
        Continue
    }
    logger_log("handle:"snl_editHandle)
    successCount := 0
    failedCount := 0
    loop, 100
    {
        BlockInput, ON
        ret_code := exec_ScenarioExecution("ahk_id " . snl_editHandle)

        Sleep, DELAY
        ret_code2 := BackToPreviousState("ahk_id " . snl_editHandle)
        if(ret_code = 0 && ret_code2 = 0)
        {
            successCount++  
        }
        Else
        {
            failedCount++
        }
        Sleep, DELAY
        logger_log("======Test #"A_Index)
        BlockInput, OFF
    }
    logger_log("========Pass Test : "successCount)
    logger_log("========Fail Test : "failedCount)
}

logger_log("--------DONE-----------")

BackToPreviousState(mtProccessID){

    BlockInput, On
	ret_code := errorhandler_BtnClick("TButton20", "Auto Save off", "Auto Save on", "ahk_class TFM_MSEDIT", mtProccessID)
    BlockInput, Off
    if (ret_code = 0)
    {
        logger_log("Auto Save logs is Disabled.")
    }
    Else
    {
        logger_log("Auto Save logs is Enabled.")
        return 1
    }


    BlockInput, On
    ControlFocus, TPageControl1, %mtProccessID%
    ControlGet, OutputVar, Tab,, TPageControl1, %mtProccessID%
    BlockInput, Off

    While !(OutputVar = 1)
    {
        Sleep, 5
        BlockInput, On
        ControlFocus, TPageControl1, %mtProccessID%
        ControlSend,TPageControl1, {CtrlDown}{Tab}{CtrlUp}, %mtProccessID%
        ControlGet, OutputVar, Tab,, TPageControl1, %mtProccessID%
        BlockInput, Off
	}

    Return 0
}
