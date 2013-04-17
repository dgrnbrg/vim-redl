" redl.vim - Clojure REPL Enhancements
" Maintainer:   David Greenberg

if exists("g:loaded_redl") || v:version < 700 || &cp
  finish
endif
let g:loaded_redl = 1

function! redl#eval_complete(A, L, P) abort
  let prefix = matchstr(a:A, '\%(.* \|^\)\%(#\=[\[{('']\)*')
  let keyword = a:A[strlen(prefix) : -1]
  return sort(map(redl#omnicomplete(0, keyword), 'prefix . v:val.word'))
endfunction

function! redl#omnicomplete(findstart, base) abort
  if a:findstart
    let line = getline('.')[0 : col('.')-2]
    return col('.') - strlen(matchstr(line, '\k\+$')) - 1
  else
    try
      let ns = fireplace#ns()
      let results = fireplace#evalparse('(map redl.complete/->vim-omnicomplete'.
                              \' (redl.complete/completions '.s:qsym(ns).' "'.a:base.'"))')
      if type(results) == type([])
        return results
      else
        return []
      endif
    catch /.*/
      return []
    endtry
  endif
endfunction

function! s:qsym(symbol)
  if a:symbol =~# '^[[:alnum:]?*!+/=<>.:-]\+$'
    return "'".a:symbol
  else
    return '(symbol "'.escape(a:symbol, '"').'")'
  endif
endfunction


augroup redl_completion
  autocmd!
  autocmd FileType clojure setlocal omnifunc=redl#omnicomplete
augroup END

function! s:Eval(bang, line1, line2, count, args) abort
  if a:args !=# ''
    let expr = a:args
  else
    if a:count ==# 0
      normal! ^
      let line1 = searchpair('(','',')', 'bcrn', g:fireplace#skip)
      let line2 = searchpair('(','',')', 'rn', g:fireplace#skip)
    else
      let line1 = a:line1
      let line2 = a:line2
    endif
    if !line1 || !line2
      return ''
    endif
    let expr = join(getline(line1, line2), "\n")
    if a:bang
      exe line1.','.line2.'delete _'
    endif
  endif
  if a:bang
    try
      let result = fireplace#session_eval(expr)
      if a:args !=# ''
        call append(a:line1, result)
        exe a:line1
      else
        call append(a:line1-1, result)
        exe a:line1-1
      endif
    catch /^Clojure:/
    endtry
  else
    call fireplace#echo_session_eval(expr)
  endif
  return ''
endfunction

function! s:setup_eval() abort
  command! -buffer -bang -range=0 -nargs=? -complete=customlist,redl#eval_complete Eval :exe s:Eval(<bang>0, <line1>, <line2>, <count>, <q-args>)

  command! -buffer Repl :call redl#repl#create("user")
  command! -buffer ReplHere :call redl#repl#create(fireplace#ns())
endfunction

function! s:cmdwinenter()
  setlocal filetype=clojure
endfunction

function! s:cmdwinleave()
  setlocal filetype< omnifunc<
endfunction

augroup redl_eval
  autocmd!
  autocmd FileType clojure call s:setup_eval()
  autocmd CmdWinEnter @ if exists('s:input') | call s:cmdwinenter() | endif
  autocmd CmdWinLeave @ if exists('s:input') | call s:cmdwinleave() | endif
augroup END

" vim:set et sw=2:
