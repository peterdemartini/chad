local physics    = require 'physics'
local PlainGrass = require 'src.frames.plain-grass'
local BlueSky    = require 'src.frames.blue-sky'
local config     = require 'src.config'
local debug      = require('src.debug')('plain-section')

local GrassSection = {}

local screenW, screenH = display.contentWidth, display.contentHeight
local sectionWidth = (screenW / 3)
math.randomseed(os.time())

function generateChunk(startX)
  local width = math.random(100, screenW / 2)
  local height = math.random(50, screenH / 4)
  local newStartX = startX + (screenW/2)
  local endX = (startX + screenW) - width
  local x = math.random(newStartX, endX)
  local y = screenH - config.groundHeight
  return PlainGrass.new(x,y+10,width,height)
end

function GrassSection.new(startX)
  return {
    BlueSky.new(startX),
    PlainGrass.new(startX, screenH, screenW, config.groundHeight),
    generateChunk(startX),
  }
end

return GrassSection
