local debug     = require('src.debug')('chad')
local config    = require 'src.config'
local imagePath = require 'src.image-path'

local ChadCharacter = {}

function ChadCharacter.new(x, y)
	debug('creating', x, y)
	local self = {};

	local physics = require "physics"

  local width, height = 76, 76
	local jumping, running = false, false
	local onCompleteOfRunBurst, runningTransition

  self.body = display.newImageRect(imagePath('chad-still.png'), width, height)
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
			debug('[jump] already jumping')
			return
		end
		debug("[jump] jump")
		jumping = true
		running = false
		self.cancel()
    self.body:applyForce(200, -1800, self.body.x, self.body.y)
  end

	self.actionEndJump = function()
		if running then
			debug("[end jump] running, can't end jump")
			return
		end
		if not jumping then
			debug("[end jump] not jumping, can't end jump")
			return
		end
		debug("[end jump] end jumping")
		jumping = false
		self.resume()
	end

	local run = function()
		debug('[run]')
		local onCancel = function()
			debug('[run] was canceled')
			runningTransition = nil
			running = false
		end
		runningTransition = transition.to(self.body, {x=config.chadRunMoveX, delta=true, time=config.chadRunTransitionTime, onCancel=onCancel, onComplete=onCompleteOfRunBurst})
	end

	onCompleteOfRunBurst = function()
		runningTransition = nil
		debug('[on run burst]')
		if jumping then
			debug("[on run burst] jumping, can't continue running")
			return
		end
		if not running then
			debug('[on run burst] ending running loop')
			return
		end
		debug('[on run burst] running and running')
		run()
	end

	self.actionRun = function()
		if jumping or running then
			debug("[action run] can't run, already running or jumping")
			return
		end
		debug("[action run] start running")
		running = true
		self.cancel()
		run()
	end

	self.actionEndRun = function()
		if jumping then
			debug("[action end run] can't end run, already jumping")
			return
		end
		debug('[action end run] end running')
		running = false
		self.resume()
	end

	self.moveX = function(x)
		debug('[move x]')
		if running then
			debug('[move x] already running')
			return
		end
		if jumping then
			debug('[move x] already jumping')
			return
		end
		debug('[move x] starting transition')
		debug('[move x] x =', x)
		self.cancel()
		transition.to(self.body, {x=x, delta=true, time=config.scrollTransitionTime,onCancel=onCancel,onComplete=onComplete})
	end

  function addBody()
    physics.addBody(self.body, 'dynamic', getBodyOptions())
    self.body.isFixedRotation = true
    self.body.gravityScale = 2.0
  end

	addBody()

	self.cancel = function()
		debug('[cancel]')
		if self.body then
			debug('[cancel] all')
			transition.cancel(self.body)
		end
  end

	self.resume = function()
		debug('[resume]')
		self.moveX(config.scrollMovementX)
  end

	self.toFront = function()
		if self.body == nil then
			debug('[to front] body nil')
			return
		end
		self.body:toFront()
	end

	self.destroy = function()
		debug('[destroying]')
		package.loaded[physics] = nil
    physics = nil
    self.cancel()
    self.body:removeSelf()
    self.body = nil
	end

	return self;
end

return ChadCharacter
