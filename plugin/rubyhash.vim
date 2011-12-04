function! ToSymbolKeysLinewise()
  .s/['"]\(\w\+\)['"]\(\s*=>\)/:\1\2/g
  .s/\v(\{|,|^)\s*\zs(\w+):/:\2 =>/g
endfunction

function! To19KeysLinewise()
  .s/\v:(\w+)\s*\=\>/\1:/g
endfunction
