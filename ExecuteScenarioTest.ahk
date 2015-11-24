; Stress test for execute scenario
#Include <definitions>
#Include <multi>
#Include <exec>
#Include <loadsnr>
#Include <errorhandler>
#Include <logger>

global MT_MAX
global MT_Array

logger_log("------------start---------")

loop, 32
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
    logger_log("inside loop")
    logger_log("handle:"snl_editHandle)
    successCount := 0
    failedCount := 0
    loop, 100
    {
    	ret_code := exec_ScenarioExecution("ahk_id " . snl_editHandle)
    	if(ret_code = 0)
    	{
    		successCount++	
    	}
    	Else{
    		failedCount++
    	}
    	EditScenarioTab("ahk_id " . snl_editHandle)

    }
    logger_log("Pass Count : "successCount)
    logger_log("Fail Count : "failedCount)
}

logger_log("--------DONE-----------")

EditScenarioTab(mtProccessID){

	ret_code := errorhandler_BtnClick("TButton20", "Auto Save off", "Auto Save on", "ahk_class TFM_MSEDIT", mtProccessID)
	ControlFocus, TPageControl1, %mtProccessID%
    ControlGet, OutputVar, Tab,, TPageControl1, %mtProccessID%
	While !(OutputVar = 1)
	{
		Sleep, 3
		ControlFocus, TPageControl1, %mtProccessID%
        ControlSend,TPageControl1, {CtrlDown}{Tab}{CtrlUp}, %mtProccessID%
        ControlGet, OutputVar, Tab,, TPageControl1, %mtProccessID%

	} 
}