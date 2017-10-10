
local debug = require('src.debug')('actions')
local Actions = {}

function Actions.new(chad, chadDied)
  local self = {};

  local running = true

  self.onCollision = function(event)
    if not running then
      return
    end
    if event.object1.name == 'chad' or event.object2.name == 'chad' then
      if (event.object1.willKill == true or event.object2.willKill == true) and event.phase == 'began' then
        timer.performWithDelay(10, chadDied)
      end
    end
  end

  self.pause = function()
    running = false
  end

  self.play = function()
    running = true
  end

  self.destroy = function()
    debug('destroying')
    Runtime:removeEventListener("collision", self.onCollision)
  end
  Runtime:addEventListener("collision", self.onCollision)

  return self;
end


return Actions
