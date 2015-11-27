#Include <definitions>
#Include <logger>


loghandler_getFileList(path) {
	FileList =  ;

    Loop, %path%
    {
    	FileList = %FileList%%A_LoopFileName%`n
    }

    return FileList
}

loghandler_renameLogFile(logfile, index){
	global MT_PATH
	global SCENARIONAME
    StringTrimLeft, parsedfilename, logfile, 5
    newfilename := SCENARIONAME . "_" . parsedfilename ; SCENARIO NAME FROM INI FILE
    path := MT_PATH . "MT" . index . "\USER\"
    oldpath := path . logfile
    newpath := path . newfilename
    ;MsgBox, index . %oldpath%, %newpath%
    FileMove, %oldpath%,  %newpath%
    logger_Log("File is renamed from " . oldpath . " to " . newpath) 
}

loghandler_parseFileList(filelist,index){
	global SCENARIONAME
	Loop, parse, filelist , `n
	{
	    if A_LoopField =  
	        continue

	    StringCaseSense, On
	    IfNotInString, A_LoopField, %SCENARIONAME%
	    {
	    	loghandler_renameLogFile(A_LoopField, index)
		}
		else
		{
			logger_Log("No need to rename file: " . A_LoopField) 
			
		}
	}
}

loghandler_renamer() {
	global MT_MAX
	global MT_PATH
	global SCENARIONAME

	Loop, %MT_MAX%
	{
	    index := A_Index
		path := MT_PATH . "MT" . index . "\USER\*.mlog"
	    filelist := loghandler_getFileList(path)
		loghandler_parseFileList(filelist,index)
	}
}