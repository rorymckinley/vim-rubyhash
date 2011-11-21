function! ToSymbolKeysLinewise()
  .s/['"]\(\w\+\)['"]\(\s*=>\)/:\1\2/g
endfunction
