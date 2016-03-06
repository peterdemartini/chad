local debug   = require('src.debug')('blue-sky')
local config  = require 'src.config'
local BlueSky = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function BlueSky.new(startX)
  debug('creating...')
  local physics = require "physics"
  local self = {};
  self.width = screenW
  self.height = 500

  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)
  self.body.fill = {type="image", filename='images/sky/blue-sky.png'}
  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x, self.body.y = startX, 0
  self.body.name = 'sky'

  self.getBody = function()
    return self.body;
  end

  self.moveX = function(x)
    transition.to(self.getBody(), {x=self.body.x+x, time=config.scrollTransitionTime})
  end

  self.getX = function(x)
    return self.body.x
  end

  self.destroy = function()
    debug('destory')
    package.loaded[physics] = nil
    physics = nil
    transition.cancel(self.body)
    self.body:removeSelf()
    self.body = nil
  end

  return self;
end

return BlueSky
