local physics = require 'physics'

local PlainGrass = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function PlainGrass.new()
  local self = {};
  self.width = screenW
  self.height = 85
  -- self.body = display.newImageRect('images/ground.png', self.width, self.height)

  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)

  self.body.fill = {type="image", filename='images/level-1-ground.png'}
  -- display.setDefault("textureWrapX", "mirroredRepeat")
  self.body.anchorX = 0
  self.body.anchorY = 1
  self.body.x, self.body.y = 0, screenH

  self.body.name = "ground"

  self.getBody = function()
    return self.body;
  end

  function getBodyOptions()
    return {friction=1.0, density=1.0, bounce=0};
  end

  function getBodyType()
    return 'static';
  end

  function addBody()
    physics.addBody(self.getBody(), getBodyType(), getBodyOptions())
  end

  addBody()

  return self;
end

return PlainGrass
