PlainGrass = require 'src.statics.plain-grass'
BlueSky    = require 'src.statics.blue-sky'

local Plain = {}
local blueSky, plainGrass

function Plain.build(sceneGroup)
  blueSky = BlueSky.new()
  sceneGroup:insert(blueSky.getBody())

  plainGrass = PlainGrass.new()
  sceneGroup:insert(plainGrass.getBody())
end

function Plain.destroy()
  plainGrass.destroy()
  plainGrass = nil
  blueSky.destroy()
  blueSky = nil
end

return Plain
