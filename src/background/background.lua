local physics = require 'physics'

local Background = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function Background.new(groundHeight)
  local self = {};
  self.WIDTH = screenW
  self.HEIGHT = groundHeight

  self.body = display.newRect(0, 0, screenW, screenH)
  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body:setFillColor(.5)

  self.getBody = function()
    return self.body;
  end

  return self;
end

return Background
