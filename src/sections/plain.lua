PlainGrass = require 'src.statics.plain-grass'
BlueSky     = require 'src.statics.blue-sky'

local physics = require 'physics'

local Plain = {}

function Plain.build(sceneGroup)
  local blueSky = BlueSky.new()
  sceneGroup:insert(blueSky.getBody())

  local plainGrass = PlainGrass.new()
  sceneGroup:insert(plainGrass.getBody())
end

return Plain
