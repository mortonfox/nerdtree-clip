# nerdtree-clip

## Introduction

clip\_path is a [NERDTree](https://github.com/scrooloose/nerdtree)
plugin that adds a menu item to copy the full path of the selected file or
folder to the clipboard.

## Installation

### Pathogen

Use the following commands:

    cd ~/.vim/bundle
    git clone https://github.com/mortonfox/nerdtree-clip.git

### Vundle

Add the following to your vimrc:

    Plugin 'mortonfox/nerdtree-clip'

Install with ```:PluginInstall```.

### Manual Installation

Copy ```clip_path.vim``` to ```~/.vim/nerdtree_plugin/``` (*nix)
or ```~/vimfiles/nerdtree_plugin``` (Windows).

## Usage

In the NERDTree window, select the desired folder or file and type ```m```
and ```b``` to copy its path to the clipboard.
