PlainGrass = require 'src.statics.plain-grass'
BlueSky    = require 'src.statics.blue-sky'
physics    = require 'physics'

local Plain = {}
local blueSky, plainGrass

function Plain.build(sceneGroup)
  local group = display.newGroup()

  blueSky = BlueSky.new()
  group:insert(blueSky.getBody())

  plainGrass = PlainGrass.new()
  group:insert(plainGrass.getBody())

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
  if package[physics] ~= nil then
    package[physics] = nil
  end
  physics = nil
end

return Plain
