let s:is_win = has('win32') || has('win64')

let s:linker = get(g:, "easyrun_linker", executable('ld.lld') ? 'ld.lld' : 'ld')

let s:types = {
\ 'script': ['%c %o %f %a'],
\ 'run': ['%c run %o -- %a'],
\ 'run-file': ['%c run %o %f -- %a'],
\ 'cc': s:is_win
\         ? ['%c %o -o %r.exe %f', './%r.exe %a']
\         : ['%c %o -o %r %f', './%r %a'],
\ 'link': s:is_win
\         ? ['%c %o -o %r.o %f', s:linker . ' %o -o %r.exe', './%r.exe %a']
\         : ['%c %o -o %r.o %f', s:linker . ' %o -o %r', './%r %a'],
\ 'vc': ['%c %o %f /nologo /Fo$r.obj /Fe%r.exe > nul', ''],
\ 'jark': ['%c ns load %f'],
\ 'dotnet-framework': ['%c %o /nologo /out:%r.exe', './%r.exe %a'],
\ 'mono': ['%c %o -out:%r.exe', 'mono %r.exe %a'],
\ 'batch': ['%c %o /c %f %a'],
\}

call extend(s:types, get(g:, "easyrun_types", {}))

let s:config = {
\ 'awk': [{'cmd': 'awk', 'type': 'script'}],
\ 'asm': [
\   {'cmd': 'ml64', 'type': 'vc'},
\   {'cmd': 'ml',   'type': 'vc'},
\   {'cmd': 'yasm', 'type': 'link'},
\   {'cmd': 'nasm', 'type': 'link'},
\   {'cmd': 'gcc',  'type': 'cc'},
\   {'cmd': 'clang',  'type': 'cc'},
\   {'cmd': 'tcc',  'type': 'cc'},
\   {'cmd': 'as', 'type': 'link'},
\ ],
\ 'bash': [{'cmd': 'bash', 'type': 'script'}],
\ 'c': [
\   {'cmd': 'cl',    'type': 'vc'},
\   {'cmd': 'clang', 'type': 'cc'},
\   {'cmd': 'gcc',   'type': 'cc'},
\   {'cmd': 'tcc',   'type': 'cc'},
\   {'cmd': 'cc',    'type': 'cc'},
\ ],
\ 'cpp': [
\   {'cmd': 'cl',      'type': 'vc'},
\   {'cmd': 'clang++', 'type': 'cc'},
\   {'cmd': 'g++',     'type': 'cc'},
\   {'cmd': 'c++',     'type': 'cc'},
\ ],
\ 'clojure': [
\   {'cmd': 'jark',    'type': 'jark'},
\   {'cmd': 'clojure', 'type': 'script'},
\ ],
\ 'cs': [
\   {'cmd': 'dotnet', 'type': 'run', 'dir': '*.csproj'},
\   {'cmd': 'csc',    'type': 'dotnet-framework'},
\   {'cmd': 'mcs',    'type': 'mono'},
\ ],
\ 'coffee': [{'cmd': 'coffee', 'type': 'script'}],
\ 'crystal': [{'cmd': 'crystal', 'type': 'run-file'}],
\ 'd': [
\   {'cmd': 'rdmd', 'type': 'script'},
\   {'cmd': 'dmd',  'type': 'cc'},
\   {'cmd': 'ldc',  'type': 'cc'},
\   {'cmd': 'gdc',  'type': 'cc'},
\ ],
\ 'dart': [{'cmd': 'dart', 'type': 'script'}],
\ 'dosbatch': [{'cmd': 'cmd', 'type': 'batch'}],
\ 'elixir': [{'cmd': 'elixir', 'type': 'script'}],
\ 'erlang': [{'cmd': 'escript', 'type': 'script'}],
\ 'fish': [{'cmd': 'fish', 'type': 'script'}],
\ 'fortran': [{'cmd': 'gfortran', 'type': 'cc'}],
\ 'fsharp': [
\   {'cmd': 'dotnet',  'type': 'run', 'dir': '*.fsproj'},
\   {'cmd': 'fsc',     'type': 'dotnet-framework'},
\   {'cmd': 'fsharpc', 'type': 'mono'},
\ ],
\ 'go': [
\   {'cmd': 'go',     'type': 'run-file'},
\   {'cmd': 'tinygo', 'type': 'run-file'},
\   {'cmd': 'gccgo',  'type': 'cc'},
\ ],
\ 'groovy': [{'cmd': 'groovy', 'type': 'script'}],
\ 'haskell': [
\   {'cmd': 'stack',  'type': 'run', 'updir': 'stack.yaml'},
\   {'cmd': 'runghc', 'type': 'script'},
\   {'cmd': 'ghc',    'type': 'cc'},
\ ],
\ 'python': [{'cmd': 'python', 'type': 'script'}],
\}

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
  let ft = &filetype
  if !has_key(s:config, ft)
    redraw
    echohl WarningMsg
    echomsg "Filetype \"" . ft . "\" is not supported."
    echohl None
    return ""
  endif

  let conf = {}
  for c in s:config[ft]
    if executable(c.cmd)
    \  && (!has_key(c, 'dir')   || filereadable(expand(c.dir)))
    \  && (!has_key(c, 'updir') || findfile(c.updir, '.;'))
      let conf = c
      break
    else
    endif
  endfor

  if empty(conf)
    redraw
    echohl WarningMsg
    echomsg "Not found any command for filetype \"" . ft . "\"."
    echohl None
    return ""
  endif

  let cmd = join(s:types[conf.type], ' && ')
  let cmd = substitute(cmd, "%c", conf.cmd, "g")
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

  if empty(cmd)
    return
  endif

  call s:execute(cmd)
endfunction
