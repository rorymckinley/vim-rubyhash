function! ToSymbolKeysLinewise()
  .s/['"]\(\w\+\)['"]\(\s*=>\)/:\1\2/g
  .s/\v(\{|,|^)\s*\zs(\w+):/:\2 =>/g
endfunction

function! To19KeysLinewise()
  .s/\v:(\w+)\s*\=\>/\1:/g
  .s/\v(["'])(\w+)\1\s*\=\>/\2:/g
endfunction

function! ToStringKeysLinewise()
  .s/\v:(\w+)(\s*)\=\>/"\1"\2=>/g
  .s/\v(\{|,|^)\s*\zs(\w+):/"\2" =>/g
endfunction
