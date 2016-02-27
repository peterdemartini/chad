local physics = require 'physics'

local Background = {}

local screenW, screenH = display.contentWidth, display.contentHeight

display.setDefault('textureWrapX', 'mirroredRepeat')

function Background.new(groundHeight)
  local self = {};
  self.width = screenW
  self.height = 500

  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)
  self.body.fill = {type="image", filename='images/level-1-background.png'}

  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x, self.body.y = 0, 0

  self.getBody = function()
    return self.body;
  end

  function animateBackground()
    transition.to(self.body.fill, {time=7000, x=1, delta=true})
  end
  timer.performWithDelay(7000, animateBackground, 0)
  animateBackground()

  return self;
end

return Background
