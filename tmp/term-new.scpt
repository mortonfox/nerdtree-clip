on run argv
	if class of argv is list then
		try
			set dir to first item of argv
		on error
			-- If no command-line arguments, do not change directory.
			set dir to ""
		end try
	else
		-- For testing in Apple Script Editor.
		set dir to "/Applications"
	end if
	
	tell application "Terminal"
		if it is not running then
			activate
			set need_new_tab to false
		else
			set need_new_tab to true
			try
				set tmp to front window
			on error
				activate
				reopen
				set need_new_tab to false
			end try
		end if
		
		if need_new_tab then
			activate
			tell application "System Events"
				tell process "Terminal"
					-- Need the delay. Otherwise some other process may get the cmd-t.
					delay 0.2
					keystroke "t" using command down
				end tell
			end tell
		end if
		
		do script "clear; cd \"" & dir & "\"" in front window
	end tell
end run
