" ============================================================================
" File:        ag_path.vim
" Description: plugin for NERD Tree that does an ag search under the selected
" path. (Requires the ag.vim plugin.)
" Maintainer:  Po Shan Cheah <morton@mortonfox.com>
" Last Change: June 10, 2014
" ============================================================================
if exists("g:loaded_nerdtree_ag_path")
    finish
endif
let g:loaded_nerdtree_ag_path = 1

" Add menu item to NERD Tree to do an ag search under the selected path.
call NERDTreeAddMenuItem({'text': 'a(g) search', 'shortcut': 'g', 'callback': 'NERDTreeAgPath'})

function! NERDTreeAgPath()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let path = curDirNode.path.str()
    
    call inputsave()
    let search_arg = input('ag.vim: search for? ')
    call inputrestore()

    if search_arg != ''
	call ag#Ag('grep!', fnameescape(search_arg).' '.fnameescape(path))
    endif
endfunction

" vim: set tw=0 sw=4:
