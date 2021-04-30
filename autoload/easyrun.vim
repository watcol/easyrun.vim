let s:commands = {
\ 'python': 'python %f',
\}

let s:position = "top"
let s:focus = 0
let s:height = 20
let s:width = 50

function easyrun#run(...)
  let s:ft = &filetype
  if !has_key(s:commands, s:ft)
    redraw
    echohl WarningMsg
    echomsg "Filetype \"" . s:ft . "\" is not supported."
    echohl None
    return
  endif

  let s:cmd = substitute(get(s:commands, s:ft), "%f", expand("%"), "g")

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

  execute s:prefix . "terminal " . s:opts . s:cmd . " " . join(a:000)
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

