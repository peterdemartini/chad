local debug     = require('src.debug')('chad')
local config    = require 'src.config'
local imagePath = require 'src.image-path'
local physics   = require "physics"

local ChadCharacter = {}

function ChadCharacter.new()
	local width, height = 76, 76

	local shape={
		width*-0.5, height*-0.15,
		0, height*-0.2,
		width*0.3, height*-0.5,
		width*0.5, height*-0.4,
		width*0.5, 0,
		width*0.3, height*0.45,
		0, height*0.45
	}

	local body = display.newImageRect(imagePath('chad-still.png'), width, height)
	body.anchorX = 0
	body.anchorY = 0
	body.x = display.contentCenterX - width
	body.y = display.contentHeight - config.groundHeight - (height - 10)
	body.name = 'chad'

	physics.addBody(body, 'dynamic', {friction=1.0, density=3.0, bounce=0.1, shape=shape})
	body.isFixedRotation = true
	body.sensorOverlaps = 0
	body.jumpCount = 0
	body.jumping = false
	body.isDead = false
	body.running = false
	body.isKillable = true
	body.isStoppable = true

	local function onJumpEvent(event)
		if body.jumpCount > 2 then
			return
		end
		if event.phase == "began" then
			body.jumping = true
			body.jumpCount = body.jumpCount + 1
			local vx, vy = body:getLinearVelocity()
			body:setLinearVelocity( vx, 0 )
			body:applyLinearImpulse(nil, -200)
		end
	end

	function body:collision(event)
		debug("collision", event.phase, event.other.name, self.name)
		if event.other.willStop then
			if event.phase == "began" then
				self.jumping = false
				self.jumpCount = 0
			end
		end
		if event.other.willKill then
			if event.phase == "began" then
				self.isDead = true
				self:dispatchEvent({ name="dead" })
			end
		end
	end

	function body:finalize()
		body:removeEventListener("collision")
		Runtime:removeEventListener("touch", onJumpEvent)
		Runtime:removeEventListener("enterFrame", onEnterFrame)
		body = nil
	end

	local function onEnterFrame()
		if body and body.x < display.screenOriginX then
			body.isDead = true
			body:dispatchEvent({name="dead"})
		end
	end

	body:addEventListener("collision")
	body:addEventListener("finalize")
	Runtime:addEventListener("enterFrame", onEnterFrame)
	Runtime:addEventListener("touch", onJumpEvent)

	return body;
end

return ChadCharacter
