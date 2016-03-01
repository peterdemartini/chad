PlainGrass = require 'src.statics.plain-grass'
BlueSky    = require 'src.statics.blue-sky'
physics    = require 'physics'

local Plain = {}
local blueSky, plainGrass
local chunks = {}

local screenW, screenH = display.contentWidth, display.contentHeight
math.randomseed(os.time())

function generateChunk()
  local width, height = math.random(100, screenW), math.random(20, screenH / 3)
  local x, y = math.random(10, screenW / 2), (screenH - 85)
  return PlainGrass.new(x,y,width,height)
end

function Plain.build(sceneGroup)
  local group = display.newGroup()

  blueSky = BlueSky.new()
  group:insert(blueSky.getBody())

  plainGrass = PlainGrass.new(0, screenH, screenW, 85)
  group:insert(plainGrass.getBody())

  for i=1, 1,math.random(1) do
    -- chunks[i] = generateChunk()
    -- group:insert(chunks[i].getBody())
  end

  sceneGroup:insert(group)

  return group
end

function Plain.destroy()
  if plainGrass ~= nil then
    plainGrass.destroy()
    plainGrass = nil
  end
  if blueSky ~= nil then
    blueSky.destroy()
    blueSky = nil
  end
  for i=1, #chunks do
    chunks[i].destroy()
    chunks[i] = nil
  end
  if package[physics] ~= nil then
    package[physics] = nil
  end
  physics = nil
end

return Plain
