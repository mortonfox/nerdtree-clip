" ============================================================================
" File:        terminal_menu_item.vim
" Description: plugin for NERD Tree that opens selected path in Terminal.
" Maintainer:  Po Shan Cheah <morton@mortonfox.com>
" Last Change: June 28, 2016
" ============================================================================
if exists("g:loaded_nerdtree_terminal_menu")
    finish
endif
let g:loaded_nerdtree_terminal_menu = 1

" Add menu item to NERD Tree to open selected dir in Terminal.
if has("gui_mac") || has("gui_macvim") 
    call NERDTreeAddMenuItem({'text': 'open shell in (t)erminal', 'shortcut': 't', 'callback': 'NERDTreeOpenTerminal'})
endif

" There is a lot of boilerplate AppleScript here but it does the following:
" - activates terminal
" - opens a terminal if necessary
" - opens a new session
" - runs a cd command in the new session
" The first argument to osascript will be the cd path.
let s:term_script = ''
let s:term_script .= 'on run argv'."\n"
let s:term_script .= '	if class of argv is list then'."\n"
let s:term_script .= '		try'."\n"
let s:term_script .= '			set dir to first item of argv'."\n"
let s:term_script .= '		on error'."\n"
let s:term_script .= '			-- If no command-line arguments, do not change directory.'."\n"
let s:term_script .= '			set dir to ""'."\n"
let s:term_script .= '		end try'."\n"
let s:term_script .= '	else'."\n"
let s:term_script .= '		-- For testing in Apple Script Editor.'."\n"
let s:term_script .= '		set dir to "/Applications"'."\n"
let s:term_script .= '	end if'."\n"
let s:term_script .= '	'."\n"
let s:term_script .= '	tell application "Terminal"'."\n"
let s:term_script .= '		if it is not running then'."\n"
let s:term_script .= '			activate'."\n"
let s:term_script .= '			set need_new_tab to false'."\n"
let s:term_script .= '		else'."\n"
let s:term_script .= '			set need_new_tab to true'."\n"
let s:term_script .= '			try'."\n"
let s:term_script .= '				set tmp to front window'."\n"
let s:term_script .= '			on error'."\n"
let s:term_script .= '				activate'."\n"
let s:term_script .= '				reopen'."\n"
let s:term_script .= '				set need_new_tab to false'."\n"
let s:term_script .= '			end try'."\n"
let s:term_script .= '		end if'."\n"
let s:term_script .= '		'."\n"
let s:term_script .= '		if need_new_tab then'."\n"
let s:term_script .= '			activate'."\n"
let s:term_script .= '			tell application "System Events"'."\n"
let s:term_script .= '				tell process "Terminal"'."\n"
let s:term_script .= '					-- Need the delay. Otherwise some other process may get the cmd-t.'."\n"
let s:term_script .= '					delay 0.2'."\n"
let s:term_script .= '					keystroke "t" using command down'."\n"
let s:term_script .= '				end tell'."\n"
let s:term_script .= '			end tell'."\n"
let s:term_script .= '		end if'."\n"
let s:term_script .= '		'."\n"
let s:term_script .= '		do script "clear; cd \"" & dir & "\"" in front window'."\n"
let s:term_script .= '	end tell'."\n"
let s:term_script .= 'end run'."\n"

function! NERDTreeOpenTerminal()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let path = curDirNode.path.str()

    let output = system('osascript - "'.path.'"', s:term_script)
    if v:shell_error != 0
	redraw
	echohl ErrorMsg
	echomsg 'Error opening Terminal shell: '.output
	echohl None
    endif
endfunction
