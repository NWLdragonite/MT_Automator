#Include <logger>
#Include <errorhandler>


loadsnr_LoadFile(snr) {

	BlockInput, On

	retryCount := 0

	Logger_Log("Load Scenario Started")

	errorhandler_BtnWait("TButton7", "ahk_class TFM_MSEDIT", "Load scenario", "ahk_class TFM_SFR")
	
	attemptCtr := 0

	Loop
	{
		attemptCtr++
	
		Logger_Log("Attempting to Load Scenario File : "attemptCtr)
		Logger_Log("Scenario File : "snr)
		Clipboard = %snr% 

		ControlSetText, TEdit2, %snr%
		
		Logger_Log("Sending Load Scenario OK Click")
		ControlClick, TButton2

		retCode := errorhandler_LoadSnrErrorCheck(LOAD_SNR_ERR_FN, attemptCtr)

		Logger_Log("LoadSnrErrorCheck "retCode)

		If (retCode = ERR_SUCCESS)
			break

		If (retCode = ERR_MAXRETRY) {
			BlockInput, Off
			ExitApp, -1
		}
			
		
	}
	

	Logger_Log("Waiting for load scenario to complete")
	retCode := errorhandler_LoadSnrErrorCheck(LOAD_SNR_ERR_DB_VER_NOT_MATCH, 0)
	Logger_Log("Exit Load Scenario")

	BlockInput, Off
}

