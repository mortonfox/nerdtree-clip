" ============================================================================
" File:        iterm_menu_item.vim
" Description: plugin for NERD Tree that opens selected path in iTerm.
" Maintainer:  Po Shan Cheah <morton@mortonfox.com>
" Last Change: August 21, 2013
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
let s:iterm_script = "on run argv\n"
let s:iterm_script .= "  tell application \"iTerm\"\n"
let s:iterm_script .= "    set isRunning to (it is running)\n"
let s:iterm_script .= "    set myterm to (current terminal)\n"
let s:iterm_script .= "    try\n"
let s:iterm_script .= "      set tmp to myterm\n"
let s:iterm_script .= "    on error\n"
let s:iterm_script .= "      set myterm to (make new terminal)\n"
let s:iterm_script .= "    end try\n"
let s:iterm_script .= "    tell myterm\n"
let s:iterm_script .= "      if not isRunning then\n"
let s:iterm_script .= "        activate\n"
let s:iterm_script .= "      end if\n"
let s:iterm_script .= "      set newSession to (launch session \"Default\")\n"
let s:iterm_script .= "      tell the last session\n"
let s:iterm_script .= "        write text \"clear\"\n"
let s:iterm_script .= "        write text \"cd \\\"\" & item 1 of argv & \"\\\"\"\n"
let s:iterm_script .= "      end tell\n"
let s:iterm_script .= "      if not isRunning then\n"
let s:iterm_script .= "        terminate the first session\n"
let s:iterm_script .= "      end if\n"
let s:iterm_script .= "    end tell\n"
let s:iterm_script .= "  end tell\n"
let s:iterm_script .= "end run\n"

function! NERDTreeOpenIterm()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let path = curDirNode.path.str()

    let output = system('osascript - "'.path.'"', s:iterm_script)
    if v:shell_error != 0
	redraw
	echohl ErrorMsg
	echomsg 'Error opening iTerm shell: '.output
	echohl None
    endif
endfunction


