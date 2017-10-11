local debug     = require('src.debug')('chad')
local config    = require 'src.config'
local imagePath = require 'src.image-path'
local physics   = require "physics"

local ChadCharacter = {}

function ChadCharacter.new(x, y)
	local width, height = 76, 76
	local jumpCount = 0

	local shape={
		width*-0.5, height*-0.15,
		0, height*-0.2,
		width*0.3, height*-0.5,
		width*0.5, height*-0.4,
		width*0.5, 0,
		width*0.3, height*0.45,
		0, height*0.45
	}

	character = display.newImageRect(imagePath('chad-still.png'), width, height)
	character.anchorX = 0
	character.anchorY = 0
	character.x, character.y = x, y - height
	character.name = 'chad'

	physics.addBody(character, 'dynamic', {friction=1, density=3, bounce=0, shape=shape}, { isSensor = true })
	character.isFixedRotation = true
	character.sensorOverlaps = 0

	local function onJumpEvent(event)
		if jumpCount > 2 then
			return
		end
		if ( event.phase == "began" ) then
			jumpCount = jumpCount + 1
			local vx, vy = character:getLinearVelocity()
			character:setLinearVelocity( vx, 0 )
			character:applyLinearImpulse(nil, -130)
		end
	end

	function character:collision(event)
		local vx, vy = self:getLinearVelocity()
		if event.selfElement == 2 and event.other.objType == "solid" then
			if event.phase == "began" then
				jumpCount = 0
				self.sensorOverlaps = self.sensorOverlaps + 1
			elseif event.phase == "ended" then
				self.sensorOverlaps = self.sensorOverlaps - 1
			end
		end
	end

	function character:finalize()
		character:removeEventListener("collision")
		Runtime:removeEventListener("touch", onJumpEvent)
		Runtime:removeEventListener("enterFrame", onEnterFrame)
	end

	local function onEnterFrame()
		if jumpCount == 0 then
			local vx, vy = character:getLinearVelocity()
			character:setLinearVelocity( 250, 0 )
			character:applyForce( 250, 0, character.x, character.y )
		end
	end

	character:addEventListener("collision")
	character:addEventListener("finalize")
	Runtime:addEventListener("enterFrame", onEnterFrame)
	Runtime:addEventListener("touch", onJumpEvent)

	return character;
end

return ChadCharacter
