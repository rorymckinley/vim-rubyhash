if !exists('g:rubyhash_map_keys')
  let g:rubyhash_map_keys=1
endif

if g:rubyhash_map_keys==1
  nnoremap <silent> <Leader>rs :call ToSymbolKeysLinewise()<CR>
  nnoremap <silent> <Leader>rt :call ToStringKeysLinewise()<CR>
  nnoremap <silent> <Leader>rr :call To19KeysLinewise()<CR>
endif

function! ToSymbolKeysLinewise()
  call setline('.', substitute(substitute(getline('.'), '[''"]\(\w\+\)[''"]\(?=\s*=>\)', '\1:', 'g'), '\(\(?:\{|,|^\)\s*\)\(\w\+\):', '\1:\2 =>', 'g'))
endfunction

function! To19KeysLinewise()
  call setline('.', substitute(substitute(getline('.'), ':\(\w\+\)\s*=>', '\1:', 'g'), '[''"]\(\w\+\)[''"]\s*=>', '\1:', 'g'))
endfunction

function! ToStringKeysLinewise()
  call setline('.', substitute(substitute(getline('.'), ':\(\w\+\)\(?=\s*=>\)', '"\1"', 'g'), '\(\(?:\{|,|^\)\s*\)\(\w\+\):', '\1"\2" =>', 'g'))
endfunction
