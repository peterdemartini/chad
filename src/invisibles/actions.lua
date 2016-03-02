
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

  self.onScreenTouch = function(event)
    if event.phase == "began" then
      print("screen touch, jumping")
      chad.actionJump()
      -- timer.performWithDelay(700, chad.actionEndJump)
    end
    return true
  end

  self.destroy = function()
    Runtime:removeEventListener("collision", self.onCollision)
    Runtime:removeEventListener("touch", self.onScreenTouch)
  end
  Runtime:addEventListener("collision", self.onCollision)
  Runtime:addEventListener("touch", self.onScreenTouch)

  return self;
end


return Actions
