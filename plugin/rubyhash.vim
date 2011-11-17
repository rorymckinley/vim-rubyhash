function! ToSymbolKeysLinewise()
  .s/['"]\(\w\+\)['"]=>/:\1=>/g
endfunction
