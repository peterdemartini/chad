
local Actions = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function Actions.new(chad)
  local self = {};

  self.onCollision = function(event)
    if event.phase == "began" then
      obj1Type, obj2Type = event.object1.type, event.object2.type
      if obj1Type == "ground" and obj2Type == "chad" then
        chad.actionEndJump()
      end
    end
  end

  self.onScreenTouch = function(event)
    if event.phase == "began" then
      print("screen touch")
      chad.actionJump()
    end
    return true
  end

  Runtime:addEventListener("collision", self.onCollision)
  Runtime:addEventListener("touch", self.onScreenTouch)

  return self;
end

return Actions
