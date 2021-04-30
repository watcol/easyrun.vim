let s:is_win = has('win32') || has('win64')

let s:types = {
\ 'c': 'gcc',
\ 'python': 'python',
\}

call extend(s:types, get(g:, "easyrun_types", {}))

let s:commands = {
\ 'gcc': ['gcc %o -o %r %f', './%r %a'],
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
