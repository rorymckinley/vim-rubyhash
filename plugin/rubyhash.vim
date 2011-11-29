function! ToSymbolKeysLinewise()
  .s/['"]\(\w\+\)['"]\(\s*=>\)/:\1\2/g
  .s/\v(\{|,|^)\s*\zs(\w+):/:\2 =>/g
endfunction
