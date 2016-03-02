local Wall = {}



function Wall.new(position)
  local physics = require 'physics'
  local self = {};

  local function getProperties()
    local screenW, screenH = display.actualContentWidth, display.actualContentHeight
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

    return {x=x, y=y, width=width, height=height, anchorX=anchorX, anchorY=anchorY}
  end

  local properties = getProperties()
  self.body = display.newRect(properties.x, properties.y, properties.width, properties.height)
  -- self.body.fill =  { 0.3, 1, 0.5 }
  -- self.body.isVisible = true
  self.body.anchorX = properties.anchorX
  self.body.anchorY = properties.anchorY
  self.body.x, self.body.y = properties.x, properties.y
  self.body.name = 'wall'

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
