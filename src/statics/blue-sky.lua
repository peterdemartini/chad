local BlueSky = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function BlueSky.new()
  local physics = require "physics"

  local self = {};
  self.width = screenW
  self.height = 500

  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)
  self.body.fill = {type="image", filename='images/sky/blue-sky.png'}
  -- self.body.fill =  { 0.9, 0.2, 0.5 }
  -- self.body.isVisible = true
  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x, self.body.y = 0, 0
  self.body.name = 'sky'

  self.getBody = function()
    return self.body;
  end

  self.destroy = function()
    package.loaded[physics] = nil
    physics = nil
    self.body = nil
  end

  return self;
end

return BlueSky
