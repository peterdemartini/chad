PlainGrass = require 'src.statics.plain-grass'
BlueSky    = require 'src.statics.blue-sky'

local Plain = {}

local screenW, screenH = display.contentWidth, display.contentHeight
math.randomseed(os.time())

function generateChunk()
  local width, height = math.random(100, screenW / 2), math.random(50, screenH / 4)
  local x, y = math.random(screenW / 2, screenW), (screenH - 85)
  return PlainGrass.new(x,y+10,width,height)
end

function Plain.build(sceneGroup)
  local physics = require 'physics'
  local self = {}
  self.items = {}
  self.items[1] = BlueSky.new()
  sceneGroup:insert(self.items[1].getBody())

  self.items[2] = PlainGrass.new(0, screenH, screenW, 85)
  sceneGroup:insert(self.items[2].getBody())

  self.items[3] = generateChunk()
  sceneGroup:insert(self.items[3].getBody())
  sceneGroup:insert(self.items[3].getSolidBody())

  self.destroy = function()
    for i=1, #self.items do
      self.items[i].destroy()
      self.items[i] = nil
    end
    if package[physics] ~= nil then
      package[physics] = nil
    end
    physics = nil
  end

  self.moveX = function(x)
    for i=1, #self.items do
      self.items[i].moveX(x)
    end
  end

  self.getX = function()
    return self.items[1].getX()
  end

  return self
end

return Plain
