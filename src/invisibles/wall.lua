local Wall = {}

local screenW, screenH = display.actualContentWidth, display.actualContentHeight

function Wall.new(position)
  local physics = require 'physics'
  local self = {};

  local x, y, anchorX, anchorY = 0,0,0,0
  local width, height
  local edgeWidth = 1
  local willKillChad = false
  if position == 'top' then
    width = screenW
    height = edgeWidth
  end
  if position == 'left' then
    width = edgeWidth
    height = screenH
    willKillChad = true
    print("position", position)
  end
  if position == 'right' then
    width = edgeWidth
    height = screenH
    x = screenW - edgeWidth
    anchorX = 1
  end

  self.body = display.newRect(x, y, width, height)
  -- self.body.fill =  { 0.3, 1, 0.5 }
  -- self.body.isVisible = true
  self.body.anchorX = anchorX
  self.body.anchorY = anchorY
  self.body.x, self.body.y = x, y
  if willKillChad then
    self.body.name = 'death-wall'
  else
    self.body.name = 'wall'
  end

  self.getBody = function()
    return self.body;
  end

  local function getBodyOptions()
    return {friction=1.0, density=1.0, bounce=0};
  end

  local function getBodyType()
    return 'static';
  end

  local function addBody()
    physics.addBody(self.getBody(), getBodyType(), getBodyOptions())
  end

  addBody()

  self.destroy = function()
    package.loaded[physics] = nil
    physics = nil
    self.body:removeSelf()
    self.body = nil
  end

  self.update = function(x)
    self.body:toFront()
  end

  return self;
end

return Wall
