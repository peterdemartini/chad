local SolidArea = require 'src.invisibles.solid-area'

local PlainGrass = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function PlainGrass.new(x, y, width, height)
  local physics = require 'physics'
  local self = {};
  self.body = display.newRect((x + (width  / 2)), (y + (height  / 2)), width, height)

  self.body.fill = {type="image", filename='images/level-1-ground.png'}
  -- self.body.fill =  { 0.4, 0.4, 0.9 }
  -- self.body.isVisible = true
  self.body.anchorX = 0
  self.body.anchorY = 1
  self.body.x, self.body.y = x, y

  self.body.name = "ground"

  self.solidArea = SolidArea.new(x, y - height + 10, width, height - 10)

  self.getBody = function()
    return self.body;
  end

  self.getSolidBody = function()
    return self.solidArea.getBody();
  end

  self.moveX = function(x)
    self.body.x = self.body.x + x
    self.solidArea.moveX(x)
  end

  self.getX = function()
    return self.body.x
  end

  self.destroy = function()
    package.loaded[physics] = nil
    physics = nil
    self.body:removeSelf()
    self.body = nil
    self.solidArea.destroy()
    self.solidArea = nil
  end

  return self;
end

return PlainGrass
