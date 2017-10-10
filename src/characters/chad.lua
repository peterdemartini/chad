local debug     = require('src.debug')('chad')
local config    = require 'src.config'
local imagePath = require 'src.image-path'

local ChadCharacter = {}

function ChadCharacter.new(x, y)
	debug('creating', x, y)
	local self = {};

	local physics = require "physics"

  local width, height = 76, 76
	local jumping = false
	local running = true
	local jumpCount = 0
	local onCompleteOfRunBurst, runningTransition

  character = display.newImageRect(imagePath('chad-still.png'), width, height)
  character.anchorX = 0
  character.anchorY = 0
  character.x, character.y = x, y - height

	character.name = 'chad'

  self.getBody = function()
    return character;
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

	local startRunning = function()
		debug('[run]')
		if jumping or running then
			debug("[action run] can't run, already running or jumping")
			return
		end
		running = true
		local vx, vy = character:getLinearVelocity()
    character:setLinearVelocity( vx, 0 )
    character:applyForce( -10, nil, character.x, character.y )
	end

  physics.addBody(character, 'dynamic', getBodyOptions(), { isSensor = true })
  character.isFixedRotation = true
	character.sensorOverlaps = 0
  character.gravityScale = 2.0

	local function onJumpEvent(event)
		if ( event.phase == "began" ) then
			if jumpCount > 2 then
				debug('[jump] jump count exceeded')
				return
			end
			jumpCount = jumpCount + 1
			debug("[jump] jump")
			jumping = true
			running = false
			local vx, vy = character:getLinearVelocity()
			character:setLinearVelocity( vx, 0 )
			character:applyLinearImpulse( 5, -50, character.x, character.y )
		end
	end
	Runtime:addEventListener("touch", onJumpEvent)

	local function sensorCollide( self, event )
    if ( event.selfElement == 2 and event.other.objType == "solid" ) then
	        if ( event.phase == "began" ) then
	            self.sensorOverlaps = self.sensorOverlaps + 1
	        elseif ( event.phase == "ended" ) then
	            self.sensorOverlaps = self.sensorOverlaps - 1
							jumpCount = 0
	        end
	    end
	end
	character.collision = sensorCollide
	character:addEventListener( "collision" )

	self.moveX = function()
	end

	self.toFront = function()
		if character == nil then
			debug('[to front] body nil')
			return
		end
		character:toFront()
	end

	self.destroy = function()
		debug('[destroying]')
		package.loaded[physics] = nil
    physics = nil
		Runtime:addEventListener("touch", onJumpEvent)
    character:removeSelf()
    character = nil
	end

	return self;
end

return ChadCharacter
