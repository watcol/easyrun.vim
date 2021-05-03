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
- AWK
  - awk
  - gawk (GNU awk)
  - mawk
  - nawk
- Bash
- C
  - Visual C
  - GCC
  - Clang
  - Tiny C Compiler
  - cc
- C++
  - Visual C++
  - GCC (g++)
  - Clang++
  - c++
- Clojure
  - Jark
  - Clojure CLI
- C#
  - .NET
  - .NET Framework
  - Mono
- CoffeeScript
- Crystal
- D
  - DMD
  - LDC
  - GDC
- Dart
- DOS Batch File
- Elixir
- Erlang
- Fish shell
- Fortran
  - GFortran
- F#
  - .NET
  - .NET Framework
  - Mono
- Go
- Groovy
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