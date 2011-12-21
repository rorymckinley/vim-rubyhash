function! ToSymbolKeysLinewise()
  :ruby Convert::to_symbols
endfunction

function! To19KeysLinewise()
  .s/\v:(\w+)\s*\=\>/\1:/g
  .s/\v(["'])(\w+)\1\s*\=\>/\2:/g
endfunction

function! ToStringKeysLinewise()
  .s/\v:(\w+)(\s*)\=\>/"\1"\2=>/g
  .s/\v(\{|,|^)\s*\zs(\w+):/"\2" =>/g
endfunction

ruby << EOF
module Convert
  def self.to_symbols
    contents = VIM::Buffer.current.line
    contents.gsub!(/['"](\w+)['"](\s*=>)/, ':\1\2')
    contents.gsub!(/((?:\{|,|^)\s*)(\w+):/, '\1:\2 =>')
    VIM::Buffer.current.line = contents
  end
end
EOF
