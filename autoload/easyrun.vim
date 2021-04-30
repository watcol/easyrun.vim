let s:commands = {
\ 'python': ['python %o %f %a'],
\ 'c': ['gcc %o -o %r %f', './%r %a']
\}

let s:position = "top"
let s:focus = 0
let s:height = 20
let s:width = 50

function easyrun#run(...)
  if !has('terminal')
    redraw
    echohl WarningMsg
    echomsg "+terminal feature is needed."
    echohl None
    return
  endif

  let s:ft = &filetype
  if !has_key(s:commands, s:ft)
    redraw
    echohl WarningMsg
    echomsg "Filetype \"" . s:ft . "\" is not supported."
    echohl None
    return
  endif

  let s:args = { "args":[], "opts": [] }
  for arg in a:000
    if arg[0] == '+'
      call add(s:args.opts, arg[1:])
    else
      call add(s:args.args, arg)
    endif
  endfor

  let s:cmd = join(s:commands[s:ft], ' && ')
  let s:cmd = substitute(s:cmd, "%f", expand("%"), "g")
  let s:cmd = substitute(s:cmd, "%r", expand("%:r"), "g")
  let s:cmd = substitute(s:cmd, "%o", join(s:args.opts), "g")
  let s:cmd = substitute(s:cmd, "%a", join(s:args.args), "g")
  if has('win32') || has('win64')
    let s:cmd = "cmd.exe /c (" . s:cmd . ")"
  else
    let s:cmd = "sh -c \"" . s:cmd . "\""
  endif

  let s:prefix = ""
  let s:pos = get(s:, "position", "bottom")
  if s:pos ==? "left" || s:pos ==? "right"
    set nosplitright
    let s:prefix = s:prefix . "vsplit | "
    if exists("s:width")
      let s:prefix = s:prefix . "vertical resize" . s:width . " | "
    endif
  else
    let s:prefix = s:prefix . "split | "
    if exists("s:height")
      let s:prefix = s:prefix . "resize" . s:height . " | "
    endif
  endif

  let s:opts = ""
  if !has('nvim')
    let s:opts = "++curwin "
  endif

  let s:right = &splitright
  let s:below = &splitbelow

  if s:pos ==? "left"
    set nosplitright
  elseif s:pos ==? "right"
    set splitright
  elseif s:pos ==? "top"
    set nosplitbelow
  else
    set splitbelow
  endif

  execute s:prefix . "terminal " . s:opts . s:cmd
  if !get(s:, "focus", 0)
    wincmd p
  endif

  if s:right
    set splitright
  else
    set nosplitright
  endif

  if s:below
    set splitbelow
  else
    set nosplitbelow
  endif
endfunction

