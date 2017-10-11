local debug   = require('src.debug')('wall')
local Wall    = require("src.invisibles.wall")
local physics = require 'physics'

local Walls   = {}

function Walls.new()
  local group = display:newGroup()
  group:insert(Wall.new("top"))
  group:insert(Wall.new("left"))
  group:insert(Wall.new("right"))
  return group;
end

return Walls
