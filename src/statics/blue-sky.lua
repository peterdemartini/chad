local physics = require 'physics'

local BlueSky = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function BlueSky.new()
  local self = {};
  self.width = screenW
  self.height = 500

  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)
  self.body.fill = {type="image", filename='images/sky/blue-sky.png'}

  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x, self.body.y = 0, 0
  self.body.name = 'sky'

  self.getBody = function()
    return self.body;
  end

  return self;
end

return BlueSky
