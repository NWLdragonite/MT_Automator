#Include <definitions>
#Include <errorhandler>

screen_Maintenance() {
    errorhandler_WinWait("ahk_class TFM_MT_SELECT")
    errorhandler_BtnWait("TButton2", "ahk_class TFM_MT_SELECT", "All Start", "ahk_class TFM_ALLSTART")
    errorhandler_WinWaitClose("ahk_class TFM_ALLSTART", 20)
}

screen_Login() {
    errorhandler_WinWait("ahk_class TFM_LOGIN")
    BlockInput, On
    ControlSend, TEdit1, nokia{Enter}{Enter}
    BlockInput, Off
}

screen_Exec() {
    errorhandler_WinWait("ahk_class TFM_RunMessage", 25)
    errorhandler_WinWaitClose("ahk_class TFM_RunMessage", 25)
    BlockInput, On
    ControlClick, TButton7, ahk_class TFM_MSEDIT
    BlockInput, Off
}


screen_Startup() {
    ;Close first if running before changing the configuration file
    multi_CloseIfRunning()
    multi_ParseParameters()
    config_iniRead()
    logger_Initialize()
}

screen_PushExecButton(handle) {
    ;Check if Execution Button is disabled
    ControlGet, OutputVar, Enabled, ,TBitBtn4, ahk_class TFM_MainMenu ahk_id %handle%
    while (OutputVar != 1)
    {
        ControlGet, OutputVar, Enabled, ,TBitBtn4, ahk_class TFM_MainMenu ahk_id %handle%
        Sleep, 10
    }
    BlockInput, On
    ControlClick, TBitBtn4, ahk_id %handle%
    BlockInput, Off
}