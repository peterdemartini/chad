local physics = require "physics"

ChadCharacter = {}
local moveMargin = (display.contentWidth / 4)
local tooFarX = display.contentWidth - moveMargin
local tooCloseX = moveMargin

function ChadCharacter.new(x, y)
	local self = {};

	self.jumping = false
  self.width = 76
  self.height = 76
	self.moveForward = true
  self.body = display.newImage("images/chad/chad-still-76.png")

  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x = x
  self.body.y = y - self.height

	self.body.type = "chad"

  self.getBody = function()
    return self.body;
  end

  function getBodyOptions()
    return {friction=0.5, density=1.0, bounce=0.1, radius=35};
  end

	function getBodyType()
    return "dynamic";
  end

  self.actionFire = function()
		print("firing")
  end

	self.actionJump = function()
		if self.jumping then
			return
		end
		self.jumping = true
		local facingForward = true
		if facingForward then
			xForce = 400
		else
			xForce = -400
		end
		transition.cancel(self.movingTransition)
    self.body:applyForce(xForce, -1500, self.body.x, self.body.y)
  end

	self.actionEndJump = function()
		self.jumping = false
	end

  function addBody()
    physics.addBody(self.getBody(), getBodyType(), getBodyOptions())
    self.body.isFixedRotation = true
    self.body.gravityScale = 2.0
  end

	addBody()

	function updateMoveForward()
		xPos = self.body.x + self.width
		if xPos >= tooFarX then
			self.moveForward = false
		end
		if xPos <= tooCloseX then
			self.moveForward = true
		end
	end

	function animateBackground()
		if self.jumping then
			return
		end
		moveX = 30
		if self.moveForward == false then
			moveX = (moveX * 2) * -1
		end
		updateMoveForward()
		self.movingTransition = transition.to(self.body, {time=1000, x=moveX, delta=true})
	end
	timer.performWithDelay(1000, animateBackground, 0)
	animateBackground()

	return self;
end

return ChadCharacter
