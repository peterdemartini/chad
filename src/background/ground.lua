local physics = require 'physics'

local Ground = {}

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function Ground.new(groundHeight)
  local self = {};
  self.WIDTH = screenW
  self.HEIGHT = groundHeight
  self.body = display.newImageRect('images/ground.png', screenW, groundHeight)

  self.body.anchorX = 0
  self.body.anchorY = 1
  self.body.x, self.body.y = 0, screenH

  self.getBody = function()
    return self.body;
  end

  self.getBodyOptions = function()
    local shape = { -halfW,-55, halfW,-55, halfW,55, -halfW,55 }
    return {friction=1.0, density=1.0, bounce=0, shape=groundShape};
  end

  self.getBodyType = function()
    return 'static';
  end

  self.addBody = function()
    physics.addBody(self.getBody(), self.getBodyType(), self.getBodyOptions())
  end

  return self;
end

return Ground
