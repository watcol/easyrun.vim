# easyrun.vim
Simple vim task runner using `teriminal`.

## Requirements
- [Vim](https://github.com/vim/vim) or [Neovim](https://github.com/neovim/neovim) with Terminal feature

## Install
### [Vundle](https://github.com/VundleVim/Vundle.vim)
In your `.vimrc` or `init.vim`:
```vim
Plugin 'watcol/easyrun.vim'
```

### [vim-plug](https://github.com/junegunn/vim-plug)
In your `.vimrc` or `init.vim`:
```vim
Plug 'watcol/easyrun.vim'
```

### [dein.vim](https://github.com/Shougo/dein.vim)
In your `.vimrc` or `init.vim`:
```vim
call dein#add('watcol/easyrun.vim')
```
or in TOML:
```toml
[[plugins]]
repo = 'watcol/easyrun.vim'
```

## Supported Filetypes
- Python

## Usage
Just call `EasyRun` command in vim:
```vim
:EasyRun
```
Arguments are allowed:
```vim
:EasyEun foo bar
```

Read [help](doc/easyrun.txt) for more usage.

## License
easyrun.vim is licensed under the MIT license. See [LICENSE](LICENSE) file for details.
