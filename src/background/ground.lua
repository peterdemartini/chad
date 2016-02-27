local physics = require 'physics'

local Ground = {}

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

display.setDefault('textureWrapX', 'mirroredRepeat')

function Ground.new(groundHeight)
  local self = {};
  self.width = screenW
  self.height = groundHeight
  -- self.body = display.newImageRect('images/ground.png', self.width, self.height)

  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)

  self.body.fill = {type="image", filename='images/ground.png'}
  -- display.setDefault("textureWrapX", "mirroredRepeat")
  self.body.anchorX = 0
  self.body.anchorY = 1
  self.body.x, self.body.y = 0, screenH

  self.body.name = "ground"

  self.getBody = function()
    return self.body;
  end

  function getBodyOptions()
    local shape = { -halfW,-55, halfW,-55, halfW,55, -halfW,55 }
    return {friction=1.0, density=1.0, bounce=0, shape=groundShape};
  end

  function getBodyType()
    return 'static';
  end

  function addBody()
    physics.addBody(self.getBody(), getBodyType(), getBodyOptions())
  end

  function animateBackground()
    transition.to(self.body.fill, {time=7000, x=1, delta=true})
  end

  addBody()

  timer.performWithDelay(7000, animateBackground, 0)
  animateBackground()


  return self;
end

return Ground
