require 'meta_programming'

class Object
  define_ghost_method(/^not_.+\?$/) do |object, symbol, *args|
    symbol.to_s =~ /^not_(.+\?)$/
    regular_method = $1.to_sym
    !object.__send__(regular_method, *args)
  end
  define_ghost_method(/^is(nt|_not)_.+\?$/) do |object, symbol, *args|
    (method = symbol.to_s) =~ /^is(nt|_not)_/
    regular_method = case $1
    when 'nt' then method.gsub(/^isnt_/, 'is_').to_sym
    when '_not' then method.gsub(/^is_not_/, 'is_').to_sym
    end
    !object.__send__(regular_method, *args)
  end
end


