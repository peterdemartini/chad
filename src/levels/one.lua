local GrassSection       = require 'src.sections.grass-section'
local PitSection         = require 'src.sections.pit-section'
local SimpleGrassSection = require 'src.sections.simple-grass-section'
local config             = require 'src.config'
local debug              = require('src.debug')('level-one')

local LevelOne = {}

local sections = {
  SimpleGrassSection,
  SimpleGrassSection,
  GrassSection,
  PitSection,
  GrassSection,
  GrassSection,
  GrassSection,
  PitSection,
  GrassSection,
  PitSection,
  GrassSection,
  GrassSection,
  GrassSection,
  GrassSection,
  GrassSection,
  PitSection,
  GrassSection,
  GrassSection,
  GrassSection,
  GrassSection,
  PitSection,
  GrassSection,
  GrassSection,
  GrassSection,
  GrassSection,
  GrassSection
}

function LevelOne.new()
  local startX = display.screenOriginX
  local frames = {}

  for i = 1, #sections do
    local section = sections[i].new(startX)
    for s = 1, #section do
      local frame = section[s]
      frames[#frames + 1] = frame
    end
    startX = startX + display.contentWidth
  end

  return frames
end

return LevelOne
