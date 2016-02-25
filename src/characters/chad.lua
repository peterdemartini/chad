local physics = require "physics"

ChadCharacter = {}

function ChadCharacter.new(x, y)
	local self = {};
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

  self.actionJump = function()
		if self.jumping then
			return
		end
		self.jumping = true
    self.body:applyForce(700, -1800, self.body.x, self.body.y)
  end

	self.actionEndJump = function()
		self.jumping = false
	end

  self.addBody = function()
    physics.addBody(self.getBody(), self.getBodyType(), self.getBodyOptions())
    self.body.isFixedRotation = true
    self.body.gravityScale = 2.0
  end

	return self;
end

return ChadCharacter
