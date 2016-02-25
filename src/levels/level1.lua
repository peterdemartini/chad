local composer = require "composer"
local scene = composer.newScene()

local physics = require "physics"
physics.start(); physics.pause()

local ChadCharacter = require "src.characters.chad"

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local groundHeight = 82
local chad = ChadCharacter.new(0, screenH - groundHeight)

function scene:create( event )
	local sceneGroup = self.view

	local background = display.newRect( 0, 0, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( .5 )

	chad.addBody()

	local ground = display.newImageRect( "images/ground.png", screenW, groundHeight )
	ground.anchorX = 0
	ground.anchorY = 1
	ground.x, ground.y = 0, screenH

	local groundShape = { -halfW,-55, halfW,-55, halfW,55, -halfW,55 }
	physics.addBody( ground, "static",  {friction=1.0, density=1.0, bounce=0, shape=groundShape} )

	sceneGroup:insert( background )
	sceneGroup:insert( ground)
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


local function onScreenTouch( event )
  if event.phase == "began" then
		chad.actionJump()
  end

  return true
end

Runtime:addEventListener("touch", onScreenTouch)

return scene
