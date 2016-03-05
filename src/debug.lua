local config   = require 'src.config'

return function(key)
  return function(...)
    if not config.debug then
      return
    end
    print("["..key.."]", ...)
  end
end
