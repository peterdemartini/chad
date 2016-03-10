
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
    if obj2Name == 'chad' then
      if obj1Name == 'solid' and event.phase == 'began' then
        debug('solid collided with chad')
        chad.actionEndJump()
      end
      if obj1Name == 'death-wall' and event.phase == 'began' then
        debug('death-wall collided with chad')
        timer.performWithDelay(100, chadDied)
      end
    end
  end

  local holding = true
  local movementTimer = nil

  local shouldJump = function()
    if not running then
      return
    end
    movementTimer = nil
    debug('shouldJump', holding)
    if not holding then
      chad.actionJump()
      return
    end
    chad.actionRun()
  end

  self.onScreenTouch = function(event)
    if not running then
      return
    end
    if event.phase == "began" then
      holding = true
      debug('touch began')
      movementTimer = timer.performWithDelay(200, shouldJump)
    elseif event.phase == "ended" or event.phase == "cancelled" then
      holding = false
      debug('touch ended')
      chad.actionEndRun()
      if movementTimer then
        chad.actionJump()
        timer.cancel(movementTimer)
      end
      movementTimer = nil
    end
    return true
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
    Runtime:removeEventListener("touch", self.onScreenTouch)
    if movementTimer then
      timer.cancel(movementTimer)
    end
  end
  Runtime:addEventListener("collision", self.onCollision)
  Runtime:addEventListener("touch", self.onScreenTouch)

  return self;
end


return Actions
