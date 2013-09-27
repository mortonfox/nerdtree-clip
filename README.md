# nerdtree-iterm

## Introduction

The following NERDTree plugins are included:
* ```iterm_menu_item```: Adds a menu item to open the selected folder in iTerm. (i.e. open a shell window and cd to that folder)
* ```clip_path```: Adds a menu item to copy the selected path to the clipboard.

## Installation

Copy the ```iterm_menu_item.vim``` and ```clip_path.vim``` files to ```~/.vim/nerdtree_plugin/``` (*nix) or ```~/vimfiles/nerdtree_plugin``` (Windows).

## Usage

In the NERDTree window:
* Select the desired folder and then type ```m``` and ```i```. If the selection is on a file, this plugin will open iTerm on the enclosing folder. 
* Select the desired folder or file and type ```m``` and ```b``` to copy its path to the clipboard.
