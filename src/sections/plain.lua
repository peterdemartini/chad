local debug = require('src.debug')('plain-section')
local PlainGrass  = require 'src.statics.plain-grass'
local BlueSky     = require 'src.statics.blue-sky'
local config      = require 'src.config'

local Plain = {}

local screenW, screenH = display.contentWidth, display.contentHeight
math.randomseed(os.time())

function generateChunk()
  local width, height = math.random(100, screenW / 2), math.random(50, screenH / 4)
  local startX = ((screenW + width) / 2)
  local x = math.random(startX - width, screenW - width), (screenH - config.groundHeight)
  local y = screenH - config.groundHeight
  debug('generating chunk', width, height, x, y)
  return PlainGrass.new(x,y+10,width,height)
end

function Plain.build(sceneGroup)
  debug('building...')
  local physics = require 'physics'
  local self = {}
  self.items = {}
  self.items[1] = BlueSky.new()
  sceneGroup:insert(self.items[1].getBody())

  self.items[2] = PlainGrass.new(0, screenH, screenW, config.groundHeight)
  sceneGroup:insert(self.items[2].getBody())

  self.items[3] = generateChunk()
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

  self.getX = function()
    return self.items[1].getX()
  end

  return self
end

return Plain
