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
global SCENARIONAME := "cellsetup"
logger_Initialize()
ctr := 1
Loop, 100
{       
    logger_Log("=====MT Automation Startup test :" . i . "======")
    multi_CloseIfRunning()    
    config_iniRead()
    
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
    }
    logger_log("======= Test " . i . " success ======-")
    ctr++
}
screen_Cleanup()