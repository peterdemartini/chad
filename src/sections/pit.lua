local debug       = require('src.debug')('pit-section')
local PitHole     = require 'src.statics.pit-hole'
local PlainGrass  = require 'src.statics.plain-grass'
local BlueSky     = require 'src.statics.blue-sky'
local config      = require 'src.config'

local Pit = {}

local screenW, screenH = config.screenW, config.screenH
math.randomseed(os.time())

function Pit.new(sceneGroup, startX)
  debug('building...', startX)
  local physics = require 'physics'
  local self = {}
  self.items = {}

  self.build = function()
    self.items[1] = BlueSky.new(startX)
    sceneGroup:insert(self.items[1].getBody())
    local sectionWidth = (screenW / 3)

    self.items[2] = PlainGrass.new(startX, screenH, sectionWidth, config.groundHeight)
    sceneGroup:insert(self.items[2].getBody())

    self.items[3] = PitHole.new((startX + (sectionWidth)), screenH, sectionWidth, (config.groundHeight / 2))
    sceneGroup:insert(self.items[3].getBody())

    self.items[4] = PlainGrass.new((startX + (sectionWidth * 2)), screenH, sectionWidth, config.groundHeight)
    sceneGroup:insert(self.items[4].getBody())
  end

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

  self.cancel = function()
    for i=1, #self.items do
      self.items[i].cancel()
    end
  end

  return self
end

return Pit
