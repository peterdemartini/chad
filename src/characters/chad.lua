local ChadCharacter = {}

function ChadCharacter.new(x, y)
	local self = {};

	local physics = require "physics"

	self.jumping = false
  local width, height = 76, 76
  self.body = display.newImage("images/chad/chad-still-76.png")

	-- self.body.fill = { 1, 0, 0.5 }
  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x = x
  self.body.y = y - height
	self.running = false

	self.body.name = 'chad'

  self.getBody = function()
    return self.body;
  end

  function getBodyOptions()
		local shape={
			width*-0.5, height*-0.15,
			0, height*-0.2,
			width*0.3, height*-0.5,
			width*0.5, height*-0.4,
			width*0.5, 0,
			width*0.3, height*0.5,
			0, height*0.50
		}
    return {friction=0.5, density=1.0, bounce=0.1, radius=35};
  end

	function getBodyType()
    return "dynamic";
  end

  self.actionFire = function()
		print("firing")
  end

	self.actionJump = function()
		print("jumping")
		if self.jumping then
			return
		end
		self.jumping = true
		local facingForward = true
		if facingForward then
			xForce = 300
		else
			xForce = -300
		end
    self.body:applyForce(xForce, -2000, self.body.x, self.body.y)
  end

	self.actionEndJump = function()
		print("end jumping")
		self.jumping = false
	end

	self.actionRun = function()
		print("start running")
		self.running = true
	end

	self.actionEndRun = function()
		print("end running")
		self.running = false
	end

  function addBody()
    physics.addBody(self.getBody(), getBodyType(), getBodyOptions())
    self.body.isFixedRotation = true
    self.body.gravityScale = 2.0
  end

	addBody()

	self.moveX = function(x)
		if self.jumping then
			return
		end
		if self.running then
			x = x * -3
		end
		self.body.x = self.body.x + x
	end

	self.destroy = function()
		package.loaded[physics] = nil
		physics = nil
		self.body = nil
	end

	return self;
end

return ChadCharacter
