local debug = require('src.debug')('wall')
local physics = require 'physics'
local Wall = {}

local screenW, screenH = display.actualContentWidth, display.actualContentHeight

function Wall.new(position)
  debug('creating wall', position)
  local x, y, anchorX, anchorY = 0,0,0,0
  local width, height
  local edgeWidth = 1
  if position == 'top' then
    width = screenW
    height = edgeWidth
  end
  if position == 'left' then
    width = edgeWidth
    height = screenH
  end
  if position == 'right' then
    width = edgeWidth
    height = screenH
    x = screenW - edgeWidth
    anchorX = 1
  end

  local rect = display.newRect(x, y, width, height)
  rect.anchorX = anchorX
  rect.anchorY = anchorY
  rect.x, rect.y = x, y
  rect.name = 'wall'
  if position == "left" then
    rect.willKill = true
  else
    rect.willKill = false
  end
  rect.objType = 'solid'

  physics.addBody(rect, 'static', {friction=1.0, density=1.0, bounce=0})
  return rect;
end

return Wall
