local debug     = require('src.debug')('plain-grass')
local SolidArea = require 'src.invisibles.solid-area'
local config    = require 'src.config'

local PlainGrass = {}

local screenW, screenH = config.screenW, config.screenH

function PlainGrass.new(startX, startY, width, height)
  debug('creating...', startX, startY, width, height)
  local physics = require 'physics'
  local self = {};
  self.body = display.newRect((startX + (width  / 2)), (startY + (height  / 2)), width, height)

  self.body.fill = {type="image", filename='images/level-1-ground.png'}
  self.body.anchorX = 0
  self.body.anchorY = 1
  self.body.x, self.body.y = startX, startY

  self.body.name = "ground"

  self.solidArea = SolidArea.new(startX, startY - height + 10, width, height - 10)

  self.getBody = function()
    return self.body;
  end

  self.getSolidBody = function()
    return self.solidArea.getBody();
  end

  self.moveX = function(x)
    self.cancel()
    transition.to(self.getBody(), {x=self.body.x+x, time=config.scrollTransitionTime})
    self.solidArea.moveX(x)
  end

  self.getX = function()
    return self.body.x
  end

  self.cancel = function()
    transition.cancel(self.body)
    self.solidArea.cancel()
  end

  self.destroy = function()
    debug('destorying')
    package.loaded[physics] = nil
    physics = nil
    transition.cancel(self.body)
    self.body:removeSelf()
    self.body = nil
    self.solidArea.destroy()
    self.solidArea = nil
  end

  return self;
end

return PlainGrass
