let s:is_win = has('win32') || has('win64')

let s:types = {
\ 'awk': executable('awk') ? 'awk' : '',
\ 'asm': s:is_win && executable('ml')                ? 'masm32'    :
\        s:is_win && executable('ml64')              ? 'masm64'    :
\        executable('yasm') && executable('lld')     ? 'yasm-lld'  :
\        executable('yasm') && executable('ld')      ? 'yasm-ld'   :
\        executable('yasm') && executable('ld.gold') ? 'yasm-gold' :
\        executable('nasm') && executable('lld')     ? 'nasm-lld'  :
\        executable('nasm') && executable('ld')      ? 'nasm-ld'   :
\        executable('nasm') && executable('ld.gold') ? 'nasm-gold' :
\        executable('clang')                         ? 'clang'     :
\        executable('gcc')                           ? 'gcc'       :
\        executable('as')   && executable('lld')     ? 'as-lld'    :
\        executable('as')   && executable('ld')      ? 'as-ld'     :
\        executable('as')   && executable('ld.gold') ? 'as-gold'   : '',
\ 'bash': executable('bash') ? 'bash' : '',
\ 'c': s:is_win && executable('cl') ? 'vc'    :
\      executable('clang')          ? 'clang' :
\      executable('gcc')            ? 'gcc'   :
\      executable('tcc')            ? 'tcc'   : 'cc',
\ 'cpp': s:is_win && executable('cl') ? 'vc'      :
\        executable('clang++')        ? 'clang++' :
\        executable('g++')            ? 'g++'     : 'c++',
\ 'clojure': executable('jark') ? 'jark' : 'clojure',
\ 'cs':  filereadable(expand('*.csproj')) ? 'dotnet' :
\        executable('csc')                ? 'csc' :
\        executable('mcs')                ? 'mcs' : '',
\ 'coffee': executable('coffee') ? 'coffee' : '',
\ 'crystal': executable('crystal') ? 'crystal' : '',
\ 'd': executable('rdmd') ? 'rdmd' :
\      executable('ldc')  ? 'ldc'  :
\      executable('gdc')  ? 'gdc'  : '',
\ 'dart': executable('dart') ? 'dart' : '',
\ 'dosbatch': executable('cmd') ? 'dosbatch': '',
\ 'elixir': executable('elixir') ? 'elixir' : '',
\ 'erlang': executable('escript') ? 'erlang': '',
\ 'fish': executable('fish') ? 'fish' : '',
\ 'fortran': executable('gfortran') ? 'gfortran' : '',
\ 'fsharp': filereadable(expand('*.fsproj')) ? 'dotnet' :
\           executable('fsc')                ? 'fsc' :
\           executable('fsharpc')            ? 'fsharpc' : '',
\ 'go': executable('go')     ? 'go'     :
\       executable('tinygo') ? 'tinygo' :
\       executable('gccgo')  ? 'gccgo'  : '',
\ 'groovy': executable('groovy') ? 'groovy' : '',
\ 'haskell' !empty(findfile('stack.yaml', '.;')) ? 'stack' :
\           executable('runghc')                 ? 'runghc' : '',
\ 'python': executable('python') ? 'python' : '',
\}

call extend(s:types, get(g:, "easyrun_types", {}))

let s:commands = {
\ 'awk': ['awk %o %f %a'],
\ 'masm32': ['ml %o %f /nologo /Fo%r.obj /Fe%r.exe > nul', './%r.exe %a'],
\ 'masm64': ['ml64 %o %f /nologo /Fo%r.obj /Fe%r.exe > nul', './%r.exe %a'],
\ 'yasm-lld': s:is_win
\               ? ['yasm -o %r.o %f', 'ld.lld %o -o %r.exe %r.o', './%r.exe %a']
\               : ['yasm -o %r.o %f', 'ld.lld %o -o %r %r.o', './%r %a'],
\ 'yasm-ld': s:is_win
\               ? ['yasm -o %r.o %f', 'ld %o -o %r.exe %r.o', './%r.exe %a']
\               : ['yasm -o %r.o %f', 'ld %o -o %r %r.o', './%r %a'],
\ 'yasm-gold': s:is_win
\               ? ['yasm -o %r.o %f', 'ld.gold %o -o %r.exe %r.o', './%r.exe %a']
\               : ['yasm -o %r.o %f', 'ld.gold %o -o %r %r.o', './%r %a'],
\ 'nasm-lld': s:is_win
\               ? ['nasm -o %r.o %f', 'ld.lld %o -o %r.exe %r.o', './%r.exe %a']
\               : ['nasm -o %r.o %f', 'ld.lld %o -o %r %r.o', './%r %a'],
\ 'nasm-ld': s:is_win
\               ? ['nasm -o %r.o %f', 'ld %o -o %r.exe %r.o', './%r.exe %a']
\               : ['nasm -o %r.o %f', 'ld %o -o %r %r.o', './%r %a'],
\ 'nasm-gold': s:is_win
\               ? ['nasm -o %r.o %f', 'ld.gold %o -o %r.exe %r.o', './%r.exe %a']
\               : ['nasm -o %r.o %f', 'ld.gold %o -o %r %r.o', './%r %a'],
\ 'as-lld': s:is_win
\               ? ['as -o %r.o %f', 'ld.lld %o -o %r.exe %r.o', './%r.exe %a']
\               : ['as -o %r.o %f', 'ld.lld %o -o %r %r.o', './%r %a'],
\ 'as-ld': s:is_win
\               ? ['as -o %r.o %f', 'ld %o -o %r.exe %r.o', './%r.exe %a']
\               : ['as -o %r.o %f', 'ld %o -o %r %r.o', './%r %a'],
\ 'as-gold': s:is_win
\               ? ['as -o %r.o %f', 'ld.gold %o -o %r.exe %r.o', './%r.exe %a']
\               : ['as -o %r.o %f', 'ld.gold %o -o %r %r.o', './%r %a'],
\ 'gawk': ['gawk %o %f %a'],
\ 'mawk': ['mawk %o %f %a'],
\ 'nawk': ['nawk %o %f %a'],
\ 'bash': ['bash %o %f %a'],
\ 'vc': ['cl %o %f /nologo /Fo%r.obj /Fe%r.exe > nul', './%r.exe %a'],
\ 'gcc': s:is_win
\          ? ['gcc %o -o %r.exe %f', './%r.exe %a']
\          : ['gcc %o -o %r %f', './%r %a'],
\ 'gcc-cat-asm': ['gcc %o -S -o %r.s %f', 'cat %r.s'],
\ 'clang': s:is_win
\          ? ['clang %o -o %r.exe %f', './%r.exe %a']
\          : ['clang %o -o %r %f', './%r %a'],
\ 'clang-cat-asm': ['clang %o -S -o %r.s %f', 'cat %r.s'],
\ 'clang-cat-ir': ['clang %o -S -emit-llvm -o %r.ll %f', 'cat %r.ll'],
\ 'tcc': s:is_win
\          ? ['tcc %o -o %r.exe %f', './%r.exe %a']
\          : ['tcc %o -o %r %f', './%r %a'],
\ 'cc': s:is_win
\          ? ['cc %o -o %r.exe %f', './%r.exe %a']
\          : ['cc %o -o %r %f', './%r %a'],
\ 'g++': s:is_win
\          ? ['g++ %o -o %r.exe %f', './%r.exe %a']
\          : ['g++ %o -o %r %f', './%r %a'],
\ 'g++-cat-asm': ['g++ %o -S -o %r.s %f', 'cat %r.s'],
\ 'clang++': s:is_win
\          ? ['clang++ %o -o %r.exe %f', './%r.exe %a']
\          : ['clang++ %o -o %r %f', './%r %a'],
\ 'clang++-cat-asm': ['clang++ %o -S -o %r.s %f', 'cat %r.s'],
\ 'clang++-cat-ir': ['clang++ %o -S -emit-llvm -o %r.ll %f', 'cat %r.ll'],
\ 'c++': s:is_win
\          ? ['c++ %o -o %r.exe %f', './%r.exe %a']
\          : ['c++ %o -o %r %f', './%r %a'],
\ 'jark': ['jark ns load %f'],
\ 'clojure': ['clojure %o %f %a'],
\ 'coffee': ['coffee %o %f %a'],
\ 'dotnet': ['dotnet run %o -- %a'],
\ 'csc': ['csc %o /nologo /out:%r.exe', './%r.exe %a'],
\ 'mcs': ['mcs %o -out:%r.exe', 'mono %r.exe %a'],
\ 'crystal': ['crystal run %o %f -- %a'],
\ 'rdmd': ['rdmd %o %f %a'],
\ 'ldc': ['ldc %o -o %r %f', './%r %a'],
\ 'gdc': ['gdc %o -o %r %f', './%r %a'],
\ 'dart': ['dart %o %f %a'],
\ 'dosbatch': ['cmd %o /c %f %a'],
\ 'elixir': ['elixir %o %f %a'],
\ 'erlang': ['escript %o %f %a'],
\ 'fish': ['fish %o %f %a'],
\ 'gfortran': ['gfortran %o -o %r %f', './%r %a'],
\ 'fsc': ['fsc %o /nologo /out:%r.exe', './%r.exe %a'],
\ 'fsharpc': ['fsharpc %o -out:%r.exe', 'mono %r.exe %a'],
\ 'go': ['go run %o %f -- %a'],
\ 'tinygo': ['go run %o %f -- %a'],
\ 'gccgo': ['gccgo %o -o %r %f', './%r %a'],
\ 'groovy': ['groovy %o %f %a'],
\ 'stack': ['stack run %o -- %a'],
\ 'runghc': ['runghc %o %f %a'],
\ 'runghc-dynamic': ['runghc -dynamic %o %f %a'],
\ 'ghc': ['ghc %o -o %r %f', './%r %a'],
\ 'ghc-dynamic': ['ghc -dynamic %o -o %r %f', './%r %a'],
\ 'python': ['python %o %f %a'],
\}

call extend(s:commands, get(g:, "easyrun_commands", {}))

let s:position = get(g:, "easyrun_position", "bottom")
let s:focus = get(g:, "easyrun_focus", 0)
let s:height = get(g:, "easyrun_height", 0)
let s:width = get(g:, "easyrun_width", 0)

function s:parse_args(list)
  let args = { "args":[], "opts": [] }
  for arg in a:list
    if len(args) >= 2 && args[0] == '+'
      call add(s:args.opts, arg[1:])
    else
      call add(s:args.args, arg)
    endif
  endfor
  return args
endfunction

function s:validate()
  if !has('terminal') && !has('nvim')
    redraw
    echohl WarningMsg
    echomsg "+terminal feature is needed."
    echohl None
    return 1
  endif

  let ft = &filetype
  if get(s:types, ft, '') == ''
    redraw
    echohl WarningMsg
    echomsg "Filetype \"" . ft . "\" is not supported."
    echohl None
    return 1
  endif

  let type = s:types[ft]
  if !has_key(s:commands, type)
    redraw
    echohl WarningMsg
    echomsg "Command type \"" . type . "\" not found."
    echohl None
    return 1
  endif

  if !(s:is_win || executable('sh'))
    redraw
    echohl WarningMsg
    echomsg "Executable \"sh\" is needed on other than Windows."
    echohl None
    return 1
  endif

  return 0
endfunction

function s:command(args, opts)
  let cmd = join(s:commands[s:types[&filetype]], ' && ')
  let cmd = substitute(cmd, "%f", expand("%"), "g")
  let cmd = substitute(cmd, "%r", expand("%:r"), "g")
  let cmd = substitute(cmd, "%a", join(a:args), "g")
  let cmd = substitute(cmd, "%o", join(a:opts), "g")
  if s:is_win
    let cmd = "cmd.exe /c (" . cmd . ")"
  else
    let cmd = "sh -c \"" . cmd . "\""
  endif

  return cmd
endfunction

function s:ex_cmd()
  let ex = ""
  if s:position ==? "left" || s:position ==? "right"
    let ex = ex . "vsplit | "
    if exists("g:easyrun_width")
      let ex = ex . "vertical resize" . s:width . " | "
    endif
  else
    let ex = ex . "split | "
    if exists("g:easyrun_height")
      let ex = ex . "resize" . s:height . " | "
    endif
  endif
  let ex = ex . "terminal"
  if !has('nvim')
    let ex = ex . " ++curwin"
  endif
  return ex
endfunction

function s:execute(cmd)
  let right = &splitright
  let below = &splitbelow

  if s:position ==? "left"
    set nosplitright
  elseif s:position ==? "right"
    set splitright
  elseif s:position ==? "top"
    set nosplitbelow
  elseif s:position ==? "bottom"
    set splitbelow
  endif

  execute s:ex_cmd() . " " . a:cmd
  if !s:focus
    wincmd p
  endif

  if right
    set splitright
  else
    set nosplitright
  endif

  if below
    set splitbelow
  else
    set nosplitbelow
  endif
endfunction

function easyrun#run(...)
  if s:validate()
    return
  endif

  let args = s:parse_args(a:000)
  let cmd = s:command(args.args, args.opts)
  call s:execute(cmd)
endfunction
