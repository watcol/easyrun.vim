if exists('g:easyrun_loaded')
  finish
endif
let g:easyrun_loaded = 1

command! -nargs=* -complete=file EasyRun call easyrun#run(<f-args>)
