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

    handle := multi_MtStartupOk(A_Index)
    if handle = 0
    {
        Continue
    }
    screen_PushExecButton(handle)
    screen_Exec()

    loadsnr_LoadFile(SNR_Array[%A_Index%])

    snl_editHandle := multi_GetMacroExecHandle(A_Index)
    MT_Array[%A_Index%,%MACRO_EXEC%] := snl_editHandle
    exec_ScenarioExecution("ahk_id " . snl_editHandle)

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

    if !multi_IsHandleValid(handle) 
    {
        multi_OSD("Handle is invalid")
        Continue
    }

    exec_ScenarioExecute("ahk_id " . handle)
    SaveMWError("TRichEdit1","ahk_class TFM_MSEDIT", MT_RESULT_LOG_PATH)
}


MT_Array:=""
SNR_Array:=""

multi_CloseIfRunning()
logger_Log("====MT_LOG_END====")

;===============================
; renaming of Log File start
;===============================

logger_Log("====START: Renaming of Log Files====")
loghandler_renameLogFiles()
logger_Log("====END: Renaming of Log Files====")