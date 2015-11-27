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
SetControlDelay -1 ; Set Control sending delay to as fast as possible

;===============================
; Autoexec start
;===============================
screen_Startup()
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
    screen_ScenarioExec(A_Index)
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
    exec_ScenarioExecute("ahk_id " . handle)
    screen_ErrorLogs() 
}

screen_Cleanup()