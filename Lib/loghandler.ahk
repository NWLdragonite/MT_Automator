#Include <definitions>
#Include <logger>

loghandler_renameLogFiles() {
	global MT_MAX
	global MT_PATH
	global SCENARIONAME

	Loop, %MT_MAX%
	{
	    index := A_Index
		path := MT_PATH . "MT" . index . "\USER\*.mlog"
	    FileList =  ;

	    Loop, %path%
	    {
	    	FileList = %FileList%%A_LoopFileName%`n
	    }

		Loop, parse, FileList, `n
		{
		    if A_LoopField =  
		        continue

		    oldfilename :=  A_LoopField
		    newfilename := SCENARIONAME . "_" . A_LoopField ; SCENARIO NAME FROM INI FILE
		    oldpath := MT_PATH . "MT" . index . "\USER\" . oldfilename
		    newpath := MT_PATH . "MT" . index . "\USER\" . newfilename
		    FileMove, %oldpath%,  %newpath%
		    logger_Log("File is renamed from " . oldpath . " to " . newpath)
		}
	}
}