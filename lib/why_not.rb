require 'meta_programming'

class Object
  define_ghost_method(/^not_.+\?$/) do |object, symbol, *args|
    symbol.to_s =~ /^not_(.+\?)$/
    regular_method = $1.to_sym
    !object.__send__(regular_method, *args)
  end
end


