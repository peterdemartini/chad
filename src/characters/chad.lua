local debug  = require('src.debug')('chad')
local config = require('src.config')

local ChadCharacter = {}

function ChadCharacter.new(x, y)
	debug('creating', x, y)
	local self = {};

	local physics = require "physics"
	local moveTransition

  local width, height = 76, 76
	local jumping, running = false, false
	local onCompleteOfRunBurst

  self.body = display.newImage("images/chad/chad-still-76.png")
  self.body.anchorX = 0
  self.body.anchorY = 0
  self.body.x, self.body.y = x, y - height

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
			width*0.3, height*0.45,
			0, height*0.45
		}
    return {friction=0.5, density=1.0, bounce=0.1, shape=shape};
  end

	self.actionJump = function()
		if jumping then
			debug('already jumping')
			return
		end
		debug("jumping")
		jumping = true
		running = false
		local facingForward = true
		if facingForward then
			xForce = 300
		else
			xForce = -300
		end
		self.cancel()
    self.body:applyForce(xForce, -2000, self.body.x, self.body.y)
  end

	self.actionEndJump = function()
		if running then
			debug("running, can't end jump")
			return
		end
		if not jumping then
			debug("not jumping, can't end jump")
			return
		end
		debug("end jumping")
		self.cancel()
		jumping = false
	end

	local run = function()
		transition.to(self.body, {x=config.chadRunMoveX, delta=true, time=config.chadRunTransitionTime, onComplete=onCompleteOfRunBurst})
	end

	onCompleteOfRunBurst = function()
		debug('onCompleteOfRunBurst')
		if jumping then
			debug("jumping, can't continue running")
			return
		end
		if not running then
			debug('ending running loop')
			return
		end
		debug('running and running')
		run()
	end

	self.actionRun = function()
		if jumping or running then
			debug("can't run, already running or jumping")
			return
		end
		debug("start running")
		running = true
		run()
	end

	self.actionEndRun = function()
		if jumping then
			return
		end
		debug('end running')
		running = false
		self.cancel()
	end

	self.moveX = function(x)
		debug('move x')
		if running or jumping then
			debug('already running or jumping')
			return
		end
		self.cancel()
		transition.to(self.body, {x=x, delta=true, time=config.scrollTransitionTime})
	end

  function addBody()
    physics.addBody(self.body, 'dynamic', getBodyOptions())
    self.body.isFixedRotation = true
    self.body.gravityScale = 2.0
  end

	addBody()

	self.cancel = function()
		debug('cancel')
    transition.cancel(self.body)
  end

	self.toFront = function()
		if self.body == nil then
			return
		end
		self.body:toFront()
	end

	self.destroy = function()
		debug('destroying')
		package.loaded[physics] = nil
    physics = nil
    self.cancel()
    self.body:removeSelf()
    self.body = nil
	end

	return self;
end

return ChadCharacter
