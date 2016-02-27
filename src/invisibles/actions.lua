
local Actions = {}

local screenW, screenH = display.contentWidth, display.contentHeight
local sectionX = screenW / 4
local sectionY = screenH / 3
local sectionLeftLeft = {min=0,max=sectionX}
local sectionLeft = {min=sectionX,max=sectionX*2}
local sectionRight = {min=sectionX*2,max=sectionX*3}
local sectionRightRight = {min=sectionX*3,max=sectionX*4}
local sectionUp = {min=0,max=sectionY}

function Actions.new(chad)
  local self = {};

  self.onCollision = function(event)
    if event.phase == "began" then
      obj1Name, obj2Name = event.object1.name, event.object2.name
      if obj1Name == "ground" and obj2Name == "chad" then
        chad.actionEndJump()
      end
    end
  end

  self.onScreenTouch = function(event)
    if event.numTaps == 2 then
      chad.actionFire()
    end
    if event.phase == "began" then
      print("screen touch")
      if self.inSection(event.y, sectionUp) then
        chad.actionJump()
        return
      end
      if self.inSection(event.x, sectionLeftLeft) then
    		chad.actionMove 'leftleft'
        return
      end
      if self.inSection(event.x, sectionLeft) then
        chad.actionMove 'left'
        return
      end
      if self.inSection(event.x, sectionRight) then
        chad.actionMove 'right'
        return
      end
      if self.inSection(event.x, sectionRightRight) then
        chad.actionMove 'rightright'
        return
      end
    end

    return true
  end

  self.inSection = function(point, section)
    print("in section", point, section.min, section.max)
    if point >= section.min and point < section.max then
      print("yes it is this section")
      return true
    end
    print("nope")
    return false
  end

  Runtime:addEventListener("collision", self.onCollision)
  Runtime:addEventListener("touch", self.onScreenTouch)

  return self;
end

return Actions
