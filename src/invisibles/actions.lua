
local Actions = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function Actions.new(chad)
  local self = {};

  self.onCollision = function(event)
    if event.phase == "began" then
      local obj1Name, obj2Name = event.object1.name, event.object2.name
      print("collision", obj1Name, obj2Name)
      if obj1Name == 'solid' and obj2Name == 'chad' then
        chad.actionEndJump()
      end
    end
  end

  local holding = true
  local movementTimer = nil

  local shouldJump = function()
    print("should, jump", holding)
    movementTimer = nil
    if not holding then
      chad.actionJump()
      return
    end
    chad.actionRun()
  end

  self.onScreenTouch = function(event)
    if event.phase == "began" then
      print("should, move?")
      holding = true
      movementTimer = timer.performWithDelay(200, shouldJump)
    elseif event.phase == "ended" or event.phase == "cancelled" then
      print("ended move")
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
