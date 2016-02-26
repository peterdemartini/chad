local physics = require "physics"

ChadCharacter = {}

function ChadCharacter.new(x, y)
	local self = {};

	self.jumping = false
	self.moving = false
  self.WIDTH = 128
  self.HEIGHT = 128
  self.body = display.newImage("images/chad/Chad-Dino-128x128.png")

  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x = x
  self.body.y = y - self.HEIGHT

	self.body.name = "chad"

  self.getBody = function()
    return self.body;
  end

  self.getBodyOptions = function()
    return {friction=0.5, density=1.0, bounce=0.1, radius=35};
  end

  self.getBodyType = function()
    return "dynamic";
  end

  self.actionFire = function()
  end

	self.actionJump = function()
		if self.jumping then
			return
		end
		self.jumping = true
		local yForce, xForce = 0, 0
		if self.body.xScale == 1 then
			print("going forward")
			yForce = -1800
			xForce = 700
		end
		if self.body.xScale == -1 then
			print("turned around")
			yForce = 5000
			xForce = -3000
		end
    self.body:applyForce(xForce, yForce, self.body.x, self.body.y)
  end

	self.actionEndJump = function()
		self.jumping = false
	end

	self.actionEndMove = function()
		self.moving = false
	end

	self.actionMove = function(direction)
		if self.jumping then
			return
		end
		if self.moving then
			return
		end
		self.moving = true
		print("move direction", direction)
		local movement = 20
		local x = self.body.x
		local xScale = 0
		if direction == 'leftleft' then
			xScale = -1
			x = x + ( movement * -2 )
		end
		if direction == 'left' then
			xScale = -1
			x = x + ( -movement )
		end
		if direction == 'right' then
			xScale = 1
			x = x + ( movement )
		end
		if direction == 'rightright' then
			xScale = 1
			x = x + ( movement * 2 )
		end

		transition.to(self.body, { x=x, xScale=xScale, time=100, transition=easing.inOutCubic,
		  onComplete=function( object )
				self.moving = false
				print("DONE MOVING")
		  end
		})
	end

  self.addBody = function()
    physics.addBody(self.getBody(), self.getBodyType(), self.getBodyOptions())
    self.body.isFixedRotation = true
    self.body.gravityScale = 2.0
  end

	return self;
end

return ChadCharacter
