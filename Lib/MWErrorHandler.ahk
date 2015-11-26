global mw_fileName
global mw_txtCtrl
global mw_txtWin

IsHead(strLine)
{
	IfInString, strLine, Send
	{
		return True
	}
	Else IfInString, strLine, Receive
	{
		return True
	}
	Else IfInString, strLine, End of scenario
	{
		return True
	}
	Else
	{
		return False
	}	
}
IsFoot(strLine)
{
	IfInString, strLine, Reception result
	{
		return True
	}
	Else IfInString, strLine, Execution result
	{
		return True
	}
	Else
	{
		return False
	}
}
SaveMWError(editCtrl,ctrlWindow,name) {	
	mw_txtCtrl := editCtrl
	mw_txtWin := ctrlWindow
	mw_fileName := name
	
	FileDelete, %mw_fileName%	
	
	cur := 1
	MAX_LINES := 0
	str := ""	
	head := 0
	foot := 0

	ControlGet, MAX_LINES, LineCount, , %mw_txtCtrl%, %mw_txtWin%
	Loop
	{
		ControlGet, str, Line, %cur%,  %mw_txtCtrl%, %mw_txtWin%
		
		if (IsHead(str) = True)
		{			
			if(head != 0 and foot != 0 and head < foot)
			{
				SaveLog(head,foot)
				head := 0
				foot := 0
			}

			head := cur
		}
		if (IsFoot(str) = True)
		{
			IfNotInString, str, result  0
			{
				foot := cur
			}			
		}
					
		if( cur > MAX_LINES)
			Break

		cur++
	}	
}


SaveLog(strStart,strEnd) {
	y := strStart
	n := strEnd	
	FileAppend, ----------------------------------------`n,  %mw_fileName%
	Loop
	{
		xStr := ""
		if (y > n)
		{
			Break
		}
		Else
		{			
			ControlGet, xStr, Line, %y%, %mw_txtCtrl%, %mw_txtWin%
			FileAppend, %xStr%`n,  %mw_fileName%
		}
		y := y + 1
	}
	FileAppend, ----------------------------------------`n, %mw_fileName%
}
