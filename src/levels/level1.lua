local composer = require 'composer'
local scene = composer.newScene()

local physics = require 'physics'
physics.start(); physics.pause()

local ChadCharacter = require 'src.characters.chad'
local Ground = require 'src.background.ground'
local Background = require 'src.background.background'

local screenH = display.contentHeight
local groundHeight = 82
local chad = ChadCharacter.new(0, screenH - groundHeight)

function scene:create(event)
	local sceneGroup = self.view

	local background = Background.new()
	local ground = Ground.new(groundHeight)

	ground.addBody()
	chad.addBody()

	sceneGroup:insert(background.getBody())
	sceneGroup:insert(ground.getBody())
	sceneGroup:insert(chad.getBody())
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )
	-- Called prior to the removal of scene's "view" (sceneGroup)
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

local function onCollision( event )
  if(event.phase == "began") then
		obj1Name, obj2Name = event.object1.name, event.object2.name
    if(obj1Name == "ground" and obj2Name == "chad") then
      chad.actionEndJump()
    end
  end
end

local function onScreenTouch( event )
  if event.phase == "began" then
		chad.actionJump()
  end

  return true
end

Runtime:addEventListener("collision", onCollision)
Runtime:addEventListener("touch", onScreenTouch)

return scene
