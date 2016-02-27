
local Actions = {}

local screenW, screenH = display.contentWidth, display.contentHeight

function Actions.new(chad)
  local self = {};

  self.onCollision = function(event)
    if event.phase == "began" then
      obj1Name, obj2Name = event.object1.name, event.object2.name
      if obj1Name == "ground" and obj2Name == "chad" then
        print("collision, end jump")
        chad.actionEndJump()
      end
    end
  end

  self.onScreenTouch = function(event)
    if event.phase == "began" then
      print("screen touch, jumping")
      chad.actionJump()
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
