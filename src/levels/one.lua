local Plain  = require 'src.sections.plain'
local Pit    = require 'src.sections.pit'
local config = require 'src.config'
local debug  = require('src.debug')('frame-master')

local LevelOne = {}

local series = {
  Plain,
  Pit,
  Plain,
  Plain,
  Plain,
  Pit,
  Plain,
  Pit,
  Plain,
  Plain,
  Plain,
  Plain,
  Plain,
  Pit,
  Plain,
  Plain,
  Plain,
  Plain,
  Pit,
  Plain,
  Plain,
  Plain,
  Plain,
  Plain
}

function LevelOne.new(chad)
  local screenW = config.screenW
  local group = display.newGroup()

  for i = 1, #series do
    group:insert(series[i].new((i - 1) * screenW))
  end

  function group:finalize()
    group:removeEventListener("finalize")
    Runtime:removeEventListener("enterFrame", onEnterFrame)
  end

  group:addEventListener("finalize")

  local onEnterFrame = function()
    local x = chad.x - (screenW / 2)
    transition.cancel()
    transition.to(group, {x=x, time=config.scrollTransitionTime})
  end

  Runtime:addEventListener("enterFrame", onEnterFrame)
  return group
end

return LevelOne
