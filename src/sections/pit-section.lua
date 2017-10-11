local debug      = require('src.debug')('pit-section')
local PitHole    = require 'src.statics.pit-hole'
local PlainGrass = require 'src.statics.plain-grass'
local BlueSky    = require 'src.statics.blue-sky'
local config     = require 'src.config'
local physics    = require 'physics'

local PitSection = {}

local screenW, screenH = display.contentWidth, display.contentHeight
local sectionWidth = (screenW / 3)
math.randomseed(os.time())

function PitSection.new(startX)
  return {
    BlueSky.new(startX),
    PlainGrass.new(startX, screenH, sectionWidth, config.groundHeight),
    PitHole.new((startX + (sectionWidth)), screenH, sectionWidth, (config.groundHeight / 2)),
    PlainGrass.new((startX + (sectionWidth * 2)), screenH, sectionWidth, config.groundHeight),
  }
end

return PitSection
