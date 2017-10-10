
local debug = require('src.debug')('actions')
local Actions = {}

function Actions.new(chad, chadDied)
  local self = {};

  local running = true

  self.onCollision = function(event)
    if not running then
      return
    end
    local obj1Name, obj2Name = event.object1.name, event.object2.name
    if obj2Name == 'chad' or obj1Name == 'chad' then
      if (obj1Name == 'solid' or obj2Name == 'solid') and event.phase == 'began' then
        debug('solid collided with chad')
        chad.actionEndJump()
      end
      if (obj1Name == 'death-wall' or obj2Name == 'death-wall') and event.phase == 'began' then
        debug('death-wall collided with chad')
        timer.performWithDelay(10, chadDied)
      end
      if (obj1Name == 'pit' or obj2Name == 'pit') and event.phase == 'began' then
        debug('chad fell in a pit')
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
