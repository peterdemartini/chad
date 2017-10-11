local debug     = require('src.debug')('pit-hole')
local config    = require 'src.config'
local imagePath = require 'src.image-path'
local physics   = require "physics"

local PitHole = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function PitHole.new(startX, startY, width, height)
  local rect = display.newRect((startX + (width  / 2)), (startY + (height  / 2)), width, height)
  rect.fill = {type="image", filename=imagePath('pit-hole.png')}
  rect.anchorX = 0
  rect.anchorY = 1
  rect.x, rect.y = startX, startY

  rect.name = 'pit-hole'
  rect.willStop = true
  rect.willKill = true

  local halfW = width/2
  local halfH = height/2
  local shape = {
    -halfW,-halfH + 8,
    halfW,-halfH + 8,
    halfW,halfH,
    -halfW,halfH
  }
  physics.addBody(rect, 'kinematic', {density=1.0,friction=1.0,bounce=0,shape=shape})
  return rect;
end

return PitHole
