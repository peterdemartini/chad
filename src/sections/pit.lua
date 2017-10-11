local debug      = require('src.debug')('pit-section')
local PitHole    = require 'src.statics.pit-hole'
local PlainGrass = require 'src.statics.plain-grass'
local BlueSky    = require 'src.statics.blue-sky'
local config     = require 'src.config'
local physics    = require 'physics'

local Pit = {}

local screenW, screenH = config.screenW, config.screenH
local sectionWidth = (screenW / 3)
math.randomseed(os.time())

function Pit.new(startX)
  local group = display:newGroup()

  group:insert(BlueSky.new(startX))
  group:insert(PlainGrass.new(startX, screenH, sectionWidth, config.groundHeight))
  group:insert(PitHole.new((startX + (sectionWidth)), screenH, sectionWidth, (config.groundHeight / 2)))
  group:insert(PlainGrass.new((startX + (sectionWidth * 2)), screenH, sectionWidth, config.groundHeight))

  function group:finalize()
    group:removeEventListener("finalize")
  end

  group:addEventListener("finalize")
  return group
end

return Pit
