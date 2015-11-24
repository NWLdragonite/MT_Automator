global mw_fileName
global mw_txtCtrl
global mw_txtWin

SaveMWError(editCtrl,ctrlWindow,name) {	
	mw_txtCtrl := editCtrl
	mw_txtWin := ctrlWindow
	mw_fileName := name
	FileDelete, %mw_fileName%
	n := 1
	numOfLines := 0
	str := ""
	ControlGet, numOfLines, LineCount, , %mw_txtCtrl%, %mw_txtWin%
	Loop, %numOfLines%
	{		
		FindFoot(n,"Reception result  ")	
		n := n + 1
	}
}

FindFoot(n,qFoot) {	
	ControlGet, str, Line, %n%, %mw_txtCtrl%, %mw_txtWin%
	IfInString str, %qFoot%
	{				
		IfInString, str, %qFoot%0
		{			
		}
		Else
		{
			y1 := FindHead(n, "Receive")
			y2 := FindHead(n, "Send")			
			if (y1 > y2)			
				y := y1
			else 
				y := y2

			if(y != 0)
			{
				SaveLog(y,n)
			}
		}
	}
}

FindHead(footPos,qHead) {
	y := footPos
	Loop
	{
		y := y - 1
		if y > 0
		{
			xStr := ""
			ControlGet, xStr, Line, %y%, %mw_txtCtrl%, %mw_txtWin%
			IfInString, xStr, %qHead%
			{
				return %y%
			}					
		}
		else 
			return 0
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
