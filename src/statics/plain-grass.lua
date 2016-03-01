local SolidArea = require 'src.invisibles.solid-area'

local PlainGrass = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function PlainGrass.new(x, y, width, height)
  local physics = require 'physics'
  local self = {};
  self.width = width
  self.height = height

  self.group = display.newGroup()
  self.body = display.newRect(display.contentCenterX, display.contentCenterY, self.width, self.height)

  self.body.fill = {type="image", filename='images/level-1-ground.png'}
  self.body.anchorX = 0
  self.body.anchorY = 1
  self.body.x, self.body.y = x, y

  self.body.name = "ground"
  self.group:insert(self.body)

  self.solidArea = SolidArea.new(x, y - height + 3, width, 10)
  self.group:insert(self.solidArea.getBody())

  self.getBody = function()
    return self.group;
  end

  self.destroy = function()
    package.loaded[physics] = nil
    physics = nil
    self.group:remove()
    self.group = nil
    self.body = nil
    self.solidArea.destroy()
    self.solidArea = nil
  end

  return self;
end

return PlainGrass
