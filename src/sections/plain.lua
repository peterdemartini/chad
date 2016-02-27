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
  plainGrass.destroy()
  plainGrass = nil
  blueSky.destroy()
  blueSky = nil
  package[physics] = nil
  physics = nil
end

return Plain
