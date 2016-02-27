Base = require 'src.statics.base'

local screenW = display.contentWidth
local image = 'images/sky/blue-sky.png'
plainGrass = Base.new('sky', 0, 0, {width=screenW,height=500,image=image})

return plainGrass
