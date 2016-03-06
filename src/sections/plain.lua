local debug       = require('src.debug')('plain-section')
local PlainGrass  = require 'src.statics.plain-grass'
local BlueSky     = require 'src.statics.blue-sky'
local config      = require 'src.config'

local Plain = {}

local screenW, screenH = config.screenW, config.screenH
math.randomseed(os.time())

function generateChunk(startX)
  local width, height = math.random(100, screenW / 2), math.random(50, screenH / 4)
  local newStartX = startX + (screenW/2)
  local endX = (startX + screenW) - width
  local x = math.random(newStartX, endX)
  local y = screenH - config.groundHeight
  debug('generating chunk', width, height, x, y)
  return PlainGrass.new(x,y+10,width,height)
end

function Plain.build(sceneGroup, startX)
  debug('building...', startX)
  local physics = require 'physics'
  local self = {}
  self.items = {}
  self.items[1] = BlueSky.new(startX)
  sceneGroup:insert(self.items[1].getBody())

  self.items[2] = PlainGrass.new(startX, screenH, screenW, config.groundHeight)
  sceneGroup:insert(self.items[2].getBody())

  self.items[3] = generateChunk(startX)
  sceneGroup:insert(self.items[3].getBody())

  self.destroy = function()
    debug('destroying...')
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

  return self
end

return Plain
