local debug     = require('src.debug')('pit-hole')
local imagePath = require 'src.image-path'
local config    = require 'src.config'

local PitHole = {}

local screenW, screenH = config.screenW, config.screenH

function PitHole.new(startX, startY, width, height)
  debug('creating...', startX, startY, width, height)
  local physics = require 'physics'
  local self = {};
  self.body = display.newRect((startX + (width  / 2)), (startY + (height  / 2)), width, height)

  self.body.fill = {type="image", filename=imagePath('pit-hole.png')}
  self.body.anchorX = 0
  self.body.anchorY = 1
  self.body.x, self.body.y = startX, startY

  self.body.name = 'pit'

  function addBody()
    local halfW = width/2
    local halfH = height/2
    local shape = {
      -halfW,-halfH + 8,
      halfW,-halfH + 8,
      halfW,halfH,
      -halfW,halfH
    }
    debug('shape', halfW, halfW,width,height)
    physics.addBody(self.body, 'static', {friction=1.0, density=0, bounce=0, shape=shape})
  end

  self.getBody = function()
    return self.body;
  end

  self.moveX = function(x)
    self.cancel()
    transition.to(self.body, {x=self.body.x+x, time=config.scrollTransitionTime})
  end

  self.getX = function()
    return self.body.x
  end

  self.cancel = function()
    transition.cancel(self.body)
  end

  self.destroy = function()
    debug('destorying')
    package.loaded[physics] = nil
    physics = nil
    transition.cancel(self.body)
    self.body:removeSelf()
    self.body = nil
  end

  addBody()

  return self;
end

return PitHole
