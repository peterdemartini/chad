local debug     = require('src.debug')('blue-sky')
local config    = require 'src.config'
local imagePath = require 'src.image-path'
local physics   = require "physics"

local BlueSky = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function BlueSky.new(startX)
  local rect = display.newRect(display.contentCenterX, display.contentCenterY, screenW, screenH)
  rect.fill = {type="image", filename=imagePath('blue-sky.png')}
  rect.anchorX = 0
  rect.anchorY = 0
  rect.x, rect.y = startX, 0
  rect.name = 'sky'
  return rect;
end

return BlueSky
