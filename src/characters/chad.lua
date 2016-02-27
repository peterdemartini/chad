local physics = require "physics"

ChadCharacter = {}

function ChadCharacter.new(x, y)
	local self = {};

	self.jumping = false
	self.moving = false
	self.facingForward = true
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
		local yForce, xForce
		if self.facingForward then
			yForce = -1800
			xForce = 700
		else
			yForce = -1800
			xForce = -700
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
		print("move direction", direction)
		if self.jumping then
			return
		end
		if self.moving then
			return
		end
		self.moving = true
		local movement = 20
		local x = self.body.x
		local xScale, facingForward
		if direction == 'leftleft' then
			x = x + ( movement * -2 )
			facingForward = false
			xScale = -1
		end
		if direction == 'left' then
			x = x + ( -movement )
			facingForward = false
			xScale = -1
		end
		if direction == 'right' then
			x = x + ( movement )
			facingForward = true
			xScale = 1
		end
		if direction == 'rightright' then
			x = x + ( movement * 2 )
			facingForward = true
			xScale = 1
		end

		if self.facingForward ~= facingForward then
			print("switching direction", facingForward, self.facingForward)
			switch = -1
			if facingForward == false then
				switch = 1
			end
			offset = self.WIDTH
			x = x + (offset * switch)
		end

		self.facingForward = facingForward

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
