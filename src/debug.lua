local config   = require 'src.config'

return function(key)
  return function(...)
    if config.debug ~= key and config.debug ~= '*' then
      return
    end
    print("["..key.."]", ...)
  end
end
