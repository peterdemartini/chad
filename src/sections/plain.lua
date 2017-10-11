local physics    = require 'physics'
local PlainGrass = require 'src.statics.plain-grass'
local BlueSky    = require 'src.statics.blue-sky'
local config     = require 'src.config'
local debug      = require('src.debug')('plain-section')

local Plain = {}

local screenW, screenH = config.screenW, config.screenH
local sectionWidth = (screenW / 3)
math.randomseed(os.time())

function generateChunk(startX)
  local width = math.random(100, screenW / 2)
  local height = math.random(50, screenH / 4)
  local newStartX = startX + (screenW/2)
  local endX = (startX + screenW) - width
  local x = math.random(newStartX, endX)
  local y = screenH - config.groundHeight
  debug('generating chunk', width, height, x, y)
  return PlainGrass.new(x,y+10,width,height)
end

function Plain.new(startX)
  local group = display:newGroup()

  group:insert(BlueSky.new(startX))
  group:insert(PlainGrass.new(startX, screenH, screenW, config.groundHeight))
  group:insert(generateChunk(startX))

  function group:finalize()
    group:removeEventListener("finalize")
  end

  group:addEventListener("finalize")

  return group
end

return Plain
