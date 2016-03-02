
local Actions = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function Actions.new(chad, chadDied)
  local self = {};

  self.onCollision = function(event)
    local obj1Name, obj2Name = event.object1.name, event.object2.name
    if obj2Name == 'chad' then
      if obj1Name == 'solid' and event.phase == 'began' then
        chad.actionEndJump()
      end
      if obj1Name == 'death-wall' and event.phase == 'began' then
        timer.performWithDelay(100, chadDied)
      end
    end
  end

  local holding = true
  local movementTimer = nil

  local shouldJump = function()
    movementTimer = nil
    if not holding then
      chad.actionJump()
      return
    end
    chad.actionRun()
  end

  self.onScreenTouch = function(event)
    if event.phase == "began" then
      holding = true
      movementTimer = timer.performWithDelay(200, shouldJump)
    elseif event.phase == "ended" or event.phase == "cancelled" then
      holding = false
      chad.actionEndRun()
      if movementTimer then
        chad.actionJump()
        timer.cancel(movementTimer)
      end
      movementTimer = nil
    end
    return true
  end

  self.destroy = function()
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
