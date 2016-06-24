" ============================================================================
" File:        iterm_menu_item.vim
" Description: plugin for NERD Tree that opens selected path in iTerm.
" Maintainer:  Po Shan Cheah <morton@mortonfox.com>
" Last Change: June 23, 2016
" ============================================================================
if exists("g:loaded_nerdtree_iterm_menu")
    finish
endif
let g:loaded_nerdtree_iterm_menu = 1

" Add menu item to NERD Tree to open selected dir in iTerm.
if has("gui_mac") || has("gui_macvim") 
    call NERDTreeAddMenuItem({'text': 'open shell in (i)term', 'shortcut': 'i', 'callback': 'NERDTreeOpenIterm'})
endif

" There is a lot of boilerplate AppleScript here but it does the following:
" - activates iTerm
" - opens a terminal if necessary
" - opens a new session
" - runs a cd command in the new session
" The first argument to osascript will be the cd path.
let s:iterm_script = ''
let s:iterm_script .= 'on run argv'."\n"
let s:iterm_script .= '	if class of argv is list then'."\n"
let s:iterm_script .= '		try'."\n"
let s:iterm_script .= '			set dir to first item of argv'."\n"
let s:iterm_script .= '		on error'."\n"
let s:iterm_script .= '			-- If no command-line arguments, do not change directory.'."\n"
let s:iterm_script .= '			set dir to ""'."\n"
let s:iterm_script .= '		end try'."\n"
let s:iterm_script .= '	else'."\n"
let s:iterm_script .= '		-- For testing in Apple Script Editor.'."\n"
let s:iterm_script .= '		set dir to "/Applications"'."\n"
let s:iterm_script .= '	end if'."\n"
let s:iterm_script .= '	'."\n"
let s:iterm_script .= '	tell application "iTerm"'."\n"
let s:iterm_script .= '		set gotsession to false'."\n"
let s:iterm_script .= '		if it is not running then'."\n"
let s:iterm_script .= '			-- If iTerm is not running, the activate command creates a new terminal and session, so we do not need to create a session.'."\n"
let s:iterm_script .= '			-- If iTerm is running, the activate command only brings it to the foreground and we still need to create a session.'."\n"
let s:iterm_script .= '			set gotsession to true'."\n"
let s:iterm_script .= '		end if'."\n"
let s:iterm_script .= '		activate'."\n"
let s:iterm_script .= '		'."\n"
let s:iterm_script .= '		try'."\n"
let s:iterm_script .= '			set current_term to current terminal'."\n"
let s:iterm_script .= '			set tmp to current session of current_term'."\n"
let s:iterm_script .= '		on error'."\n"
let s:iterm_script .= '			-- if iTerm is in a state where it has no open windows, create a window.'."\n"
let s:iterm_script .= '			set current_term to make new terminal'."\n"
let s:iterm_script .= '		end try'."\n"
let s:iterm_script .= '		'."\n"
let s:iterm_script .= '		-- For some reason, make new terminal does not set current terminal. So we need to use our variable here.'."\n"
let s:iterm_script .= '		tell current_term'."\n"
let s:iterm_script .= '			if not gotsession then'."\n"
let s:iterm_script .= '				-- If we did not start iTerm, then create a new session here. Otherwise, we can reuse the initial default session.'."\n"
let s:iterm_script .= '				launch session "Default"'."\n"
let s:iterm_script .= '			end if'."\n"
let s:iterm_script .= '			write current session text "clear; cd \"" & dir & "\""'."\n"
let s:iterm_script .= '		end tell'."\n"
let s:iterm_script .= '	end tell'."\n"
let s:iterm_script .= 'end run'."\n"

" This script is for iTerm 2 2.9 beta and 3.x.
" Run this using osascript. The first argument must be the initial directory
" for the shell.
" There is a lot of AppleScript here to handle the following 3 scenarios:
" - iTerm already running and there is a current window.
" - iTerm is running but with no window open.
" - iTerm is not running.
" Also, iTerm needs to be brought to the foreground and we need to open a new
" tab, if necessary, to not disrupt an existing shell session.
let s:iterm_script_v3 = ''
let s:iterm_script_v3 .= 'on run argv'."\n"
let s:iterm_script_v3 .= '	if class of argv is list then'."\n"
let s:iterm_script_v3 .= '		try'."\n"
let s:iterm_script_v3 .= '			set dir to first item of argv'."\n"
let s:iterm_script_v3 .= '		on error'."\n"
let s:iterm_script_v3 .= '			-- If no command-line argument, do not change directory.'."\n"
let s:iterm_script_v3 .= '			set dir to ""'."\n"
let s:iterm_script_v3 .= '		end try'."\n"
let s:iterm_script_v3 .= '	else'."\n"
let s:iterm_script_v3 .= '		-- For testing in Apple Script Editor'."\n"
let s:iterm_script_v3 .= '		set dir to "/Applications"'."\n"
let s:iterm_script_v3 .= '	end if'."\n"
let s:iterm_script_v3 .= '	'."\n"
let s:iterm_script_v3 .= '	tell application "iTerm"'."\n"
let s:iterm_script_v3 .= '		set gottab to false'."\n"
let s:iterm_script_v3 .= '		'."\n"
let s:iterm_script_v3 .= '		-- If iTerm is not running, then activate will run it and create a new window and tab. So we do not need to create a tab ourselves.'."\n"
let s:iterm_script_v3 .= '		-- If iTerm is already running, activate brings it to the foreground, which we want to do anyway.'."\n"
let s:iterm_script_v3 .= '		if it is not running then'."\n"
let s:iterm_script_v3 .= '			set gottab to true'."\n"
let s:iterm_script_v3 .= '		end if'."\n"
let s:iterm_script_v3 .= '		activate'."\n"
let s:iterm_script_v3 .= '		'."\n"
let s:iterm_script_v3 .= '		-- Check if iTerm has a window open.'."\n"
let s:iterm_script_v3 .= '		try'."\n"
let s:iterm_script_v3 .= '			set tmp to current tab of current window'."\n"
let s:iterm_script_v3 .= '		on error'."\n"
let s:iterm_script_v3 .= '			-- If iTerm has no windows open, create one.'."\n"
let s:iterm_script_v3 .= '			set curwindow to create window with default profile'."\n"
let s:iterm_script_v3 .= '			-- Creating a window opens a tab, so we do not need to do it ourselves.'."\n"
let s:iterm_script_v3 .= '			set gottab to true'."\n"
let s:iterm_script_v3 .= '		end try'."\n"
let s:iterm_script_v3 .= '		'."\n"
let s:iterm_script_v3 .= '		-- Create a tab if we have not already done so by running iTerm or creating a window.'."\n"
let s:iterm_script_v3 .= '		if not gottab then'."\n"
let s:iterm_script_v3 .= '			create tab with default profile current window'."\n"
let s:iterm_script_v3 .= '		end if'."\n"
let s:iterm_script_v3 .= '		'."\n"
let s:iterm_script_v3 .= '		-- Finally, we can run the commands.'."\n"
let s:iterm_script_v3 .= '		write current session of current window text "clear; cd \"" & dir & "\""'."\n"
let s:iterm_script_v3 .= '	end tell'."\n"
let s:iterm_script_v3 .= 'end run'."\n"

function! NERDTreeOpenIterm()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let path = curDirNode.path.str()

    let iterm_version = get(g:, 'nerdtree_iterm_iterm_version', 2)

    let output = system('osascript - "'.path.'"', iterm_version >= 3 ? s:iterm_script_v3 : s:iterm_script)
    if v:shell_error != 0
	redraw
	echohl ErrorMsg
	echomsg 'Error opening iTerm shell: '.output
	echohl None
    endif
endfunction
