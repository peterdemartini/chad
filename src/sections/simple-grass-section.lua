local physics    = require 'physics'
local PlainGrass = require 'src.frames.plain-grass'
local BlueSky    = require 'src.frames.blue-sky'
local config     = require 'src.config'
local debug      = require('src.debug')('plain-section')

local SimpleGrassSection = {}

local screenW, screenH = display.contentWidth, display.contentHeight
local sectionWidth = (screenW / 3)
math.randomseed(os.time())

function SimpleGrassSection.new(startX)
  return {
    BlueSky.new(startX),
    PlainGrass.new(startX, screenH, screenW, config.groundHeight),
  }
end

return SimpleGrassSection
