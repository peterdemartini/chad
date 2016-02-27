local physics = require 'physics'

local Base = {}

function Base.new(type, x, y, options)
  local self = {};
  self.body = display.newRect(display.contentCenterX, display.contentCenterY, options.width, options.height)

  self.body.fill = {type="image", filename=image}
  -- display.setDefault("textureWrapX", "mirroredRepeat")
  self.body.anchorX = options.anchorX or 0
  self.body.anchorY = options.anchorY or 0
  self.body.x, self.body.y = x, y

  self.body.type = type

  function getBodyOptions()
    if options.hasOptions == true then
      return {friction=1.0, density=1.0, bounce=0};
    end
  end

  function getBodyType()
    return 'static';
  end

  function addBody()
    physics.addBody(self.body, getBodyType(), getBodyOptions())
  end

  addBody()

  return self;
end

return Base
