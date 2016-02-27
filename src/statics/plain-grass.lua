Base = require 'src.statics.base'

local screenW = display.contentWidth
local image = 'images/level-1-ground.png'
plainGrass = Base.new('ground', 0, 0, {width=screenW,height=85,image=image,anchorY=0,hasOptions=true})

return plainGrass
