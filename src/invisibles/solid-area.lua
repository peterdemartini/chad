local debug  = require('src.debug')('solid-area')
local config = require 'src.config'
local SolidArea = {}

local screenW, screenH = config.screenW, config.screenH

function SolidArea.new(startX, startY, width, height)
  debug('solid area', startX, startY, width, height)
  local physics = require 'physics'
  local self = {};
  self.body = display.newRect((startX + (width  / 2)), (startY + (height  / 2)), width, height)

  self.body.fill =  { 1, 0.5, 0.3 }
  self.body.isVisible = false
  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x, self.body.y = startX, startY

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
    debug('destroying')
    package.loaded[physics] = nil
    physics = nil
    transition.cancel(self.body)
    self.body:removeSelf()
    self.body = nil
  end

  self.moveX = function(x)
    transition.to(self.getBody(), {x=self.body.x+x, time=config.scrollTransitionTime})
  end

  return self;
end

return SolidArea
