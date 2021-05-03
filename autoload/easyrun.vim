let s:is_win = has('win32') || has('win64')

let s:types = {
\ 'awk': 'awk',
\ 'bash': 'bash',
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
\ 'coffee': 'coffee',
\ 'crystal': 'crystal',
\ 'd': executable('rdmd') ? 'rdmd' :
\      executable('ldc')  ? 'ldc'  :
\      executable('gdc')  ? 'gdc'  : '',
\ 'dart': 'dart',
\ 'dosbatch': 'dosbatch',
\ 'elixir': 'elixir',
\ 'erlang': 'erlang',
\ 'fish': 'fish',
\ 'fortran': 'gfortran',
\ 'fsharp': filereadable(expand('*.fsproj')) ? 'dotnet' :
\           executable('fsc')                ? 'fsc' :
\           executable('fsharpc')            ? 'fsharpc' : '',
\ 'go': 'go',
\ 'groovy': 'groovy',
\ 'python': 'python',
\}

call extend(s:types, get(g:, "easyrun_types", {}))

let s:commands = {
\ 'awk': ['awk %o %f %a'],
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
\ 'groovy': ['groovy %o %f %a'],
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
  if !has_key(s:types, ft)
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
