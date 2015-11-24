global consoleOut := FileOpen("*", "w `n")
global CONSOLELOG := 1
global FILELOG    := 2

logger_Log(logmsg, switch := 1){

    If (switch = CONSOLELOG)
    {
        ConsoleLog(logmsg)
    }

    else if (switch = FILELOG)
    {
        PrintToFile(logmsg)
    } 

}

ConsoleLog(logmsg) {
    FileAppend, %logmsg%`n, *
}


PrintToFile(logmsg) {
    global MT_AUTO_LOG_PATH
    FileAppend `n%logmsg%, %MT_AUTO_LOG_PATH% 
}

logger_Initialize() {
    global MT_AUTO_LOG_PATH
    FileDelete, %MT_AUTO_LOG_PATH%
    FileAppend, ====MT_LOG_START====, %MT_AUTO_LOG_PATH%
}