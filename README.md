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
- Ada
  - GNAT (GCC Ada)
- AWK
  - awk
  - gawk (GNU awk)
  - mawk
  - nawk
- Assembly
  - MASM32
  - MASM
  - Yasm
  - NASM
  - GCC
  - as (GNU Assembler)
  - LLD *(linker)*
  - ld (GNU linker) *(linker)*
  - GNU Gold *(linker)*
- Bash
- Boo
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
  - Go
  - TinyGo
  - GCCGO
- Groovy
- Hack
- Haskell
  - Stack
  - runghc
  - GHC
- Haxe
- Idris
- IO
- Java
  - Gradle
  - Java
- JavaScript
  - Node.js
  - Deno
  - Rhino
  - PhantomJS
  - V8
  - SpiderMonkey
- JSX
- Julia
- Kotlin
  - Gradle
  - Kotlin Script
  - Kotlin
- Common Lisp
  - Steal Bank Common Lisp
  - Clozure CL
  - GNU CLISP
  - Embeddable Common Lisp
- LLVM IR
- Lua
  - LuaJIT
  - Lua
  - Redis
- Markdown
  - Markdown.pl
  - bluecloth
  - kramdown
  - Redcarpet
  - Pandoc
  - Python-Markdown
  - Discount
- Nim
- OCaml
- Perl
- Python
  - CPython
  - Pypy
  - Nuitka
  - Jython
- PHP
- Pony
- Processing
- Prolog
  - SWI-Prolog
  - GNU Prolog
- PowerShell
- PureScript
  - Spago
  - Pulp
- XQuery
  - Zorba
- R
- Racket
- Ruby
  - Ruby
  - mruby
  - Jruby
- Rust
  - Cargo
  - rustc
- Scala
  - sbt
  - Gradle
  - Scala
- Scheme
  - Gauche
  - MzScheme
  - Bigloo Scheme
  - Chicken Scheme
  - GNU Guile
- Sed
- Shell Script
- SQL
  - PostgreSQL
  - MySQL
  - SQLite3
  - Oracle SQL\*Plus
  - Microsoft SQL Server
- Swift
- tmux
- TypeScript
  - ts-node
  - Deno
  - TypeScript
- V
- Vala
- Visual Basic .NET
  - .NET
  - .NET Framework
- Windows Script Host
- Zig
- Z Shell

**NOTE: If there are multiple tools in one language, upper tools has higer priority.**

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
