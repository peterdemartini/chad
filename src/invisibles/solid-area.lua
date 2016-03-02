local SolidArea = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function SolidArea.new(x, y, width, height)
  local physics = require 'physics'
  local self = {};
  self.width = width
  self.height = height
  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)

  self.body.fill =  { 1, 0.5, 0.3 }
  self.body.isVisible = false
  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x, self.body.y = x, y

  self.body.name = "solid"

  self.getBody = function()
    return self.body;
  end

  function getBodyOptions()
    return {friction=1.0, density=2.0, bounce=0};
  end

  function getBodyType()
    return 'static';
  end

  function addBody()
    physics.addBody(self.getBody(), getBodyType(), getBodyOptions())
  end

  addBody()

  self.destroy = function()
    package.loaded[physics] = nil
    physics = nil
    self.body:removeSelf()
    self.body = nil
  end

  self.moveX = function(x)
    self.body.x = self.body.x + x
  end

  return self;
end

return SolidArea
